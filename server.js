require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static('public'));

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`
});

// Test DB connection
pool.query('SELECT NOW()', (err) => {
  if (err) {
    console.error('❌ Database connection error:', err);
  } else {
    console.log('✅ Database connected');
  }
});

// 🤖 Generate Report with Ollama
async function generateReportWithOllama(project) {
  const prompt = `
אתה כותב דוחות מקצועיים ומעניינים על פרויקטים טכנולוגיים.

פרויקט: ${project.name}
תיאור: ${project.description}
טכנולוגיות: ${project.technologies?.join(', ') || 'N/A'}
GitHub: ${project.github_url || 'N/A'}

כתוב דוח מקצועי בעברית שמכיל:
1. פתיחה מושכת (משפט אחד חזק)
2. מה הפרויקט עושה בפרט (2-3 משפטים)
3. למה זה טכנית חשוב ומעניין (2 משפטים)
4. התוצאות והשפעה (משפט אחד)
5. סיום מעוררי השראה (משפט אחד)

סגנון: מקצועי, טכני, אבל קריאטיבי וחם.
אורך: 3-4 פסקאות.
שימוש בעברית מושלמת ומילים מתחום הטכנולוגיה.
`;

  try {
    console.log(`🔄 Calling Ollama for project: ${project.name}...`);
    
    const response = await axios.post(`${process.env.OLLAMA_BASE_URL || 'http://localhost:11434'}/api/generate`, {
      model: process.env.OLLAMA_MODEL || 'mistral',
      prompt: prompt,
      stream: false,
      temperature: 0.7,
      top_p: 0.9,
      top_k: 40
    });

    console.log(`✅ Report generated for: ${project.name}`);
    return response.data.response;
  } catch (error) {
    console.error(`❌ Error generating report for ${project.name}:`, error.message);
    return null;
  }
}

// 📝 API Routes

// Get all projects
app.get('/api/projects', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM projects WHERE status = $1 ORDER BY created_at DESC', ['active']);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching projects:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get all reports
app.get('/api/reports', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT r.*, p.name as project_name, p.image_url, p.github_url
      FROM reports r
      JOIN projects p ON r.project_id = p.id
      ORDER BY r.generated_at DESC
      LIMIT 50
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching reports:', error);
    res.status(500).json({ error: error.message });
  }
});

// Generate reports for all projects
app.post('/api/generate-reports', async (req, res) => {
  try {
    console.log('🧪 Starting report generation...');
    
    const projectsResult = await pool.query(
      'SELECT * FROM projects WHERE status = $1 ORDER BY created_at ASC',
      ['active']
    );

    const projects = projectsResult.rows;
    const generatedReports = [];

    for (let project of projects) {
      console.log(`\n📋 Processing: ${project.name}`);
      
      const content = await generateReportWithOllama(project);

      if (content) {
        try {
          const reportResult = await pool.query(
            `INSERT INTO reports (project_id, title, content, summary)
             VALUES ($1, $2, $3, $4)
             ON CONFLICT (project_id) DO UPDATE
             SET content = $3, summary = $4, generated_at = NOW()
             RETURNING *`,
            [
              project.id,
              `${project.name} - Professional Report`,
              content,
              content.substring(0, 200) + '...'
            ]
          );

          generatedReports.push(reportResult.rows[0]);
          console.log(`✅ Report saved for: ${project.name}`);
        } catch (dbError) {
          console.error(`❌ Error saving report for ${project.name}:`, dbError.message);
        }
      }

      // Add delay to avoid overwhelming Ollama
      await new Promise(resolve => setTimeout(resolve, 1000));
    }

    console.log(`\n🎉 Generated ${generatedReports.length} reports!`);
    res.json({
      success: true,
      count: generatedReports.length,
      reports: generatedReports
    });
  } catch (error) {
    console.error('Error in generate-reports:', error);
    res.status(500).json({ error: error.message });
  }
});

// Add new project
app.post('/api/projects', async (req, res) => {
  try {
    const { name, description, technologies, github_url, live_url, image_url } = req.body;

    const result = await pool.query(
      `INSERT INTO projects (name, description, technologies, github_url, live_url, image_url, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [name, description, technologies, github_url, live_url, image_url, 'active']
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error creating project:', error);
    res.status(500).json({ error: error.message });
  }
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════╗
║       🧪 IvanasAlchemy Server Running        ║
║              Port: ${PORT}                      ║
║         Environment: ${process.env.NODE_ENV || 'development'}               ║
╚════════════════════════════════════════════════╝
  `);
});
