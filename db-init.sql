-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  technologies TEXT[],
  image_url VARCHAR(500),
  github_url VARCHAR(500),
  live_url VARCHAR(500),
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create reports table
CREATE TABLE IF NOT EXISTS reports (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL UNIQUE REFERENCES projects(id) ON DELETE CASCADE,
  title VARCHAR(255),
  content TEXT NOT NULL,
  summary VARCHAR(500),
  quality_score INTEGER,
  generated_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create indices
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_reports_project_id ON reports(project_id);
CREATE INDEX IF NOT EXISTS idx_reports_generated_at ON reports(generated_at DESC);

-- Insert sample projects (optional)
INSERT INTO projects (name, description, technologies, github_url, status) VALUES
  (
    'IvanasAlchemy Portal',
    'Professional portfolio platform showcasing projects with AI-generated reports',
    ARRAY['React', 'Node.js', 'PostgreSQL', 'Ollama'],
    'https://github.com/ivanamikush92-dot/Ivana-s-Alchemy',
    'active'
  ),
  (
    'AI Report Generator',
    'Automated system for generating professional project reports using local LLMs',
    ARRAY['Python', 'FastAPI', 'Ollama', 'Docker'],
    'https://github.com/ivanamikush92-dot/reports-generator',
    'active'
  ),
  (
    'Real-time Analytics Dashboard',
    'Live data visualization dashboard for project metrics and insights',
    ARRAY['Vue.js', 'WebSocket', 'PostgreSQL', 'D3.js'],
    'https://github.com/ivanamikush92-dot/analytics-dashboard',
    'active'
  )
ON CONFLICT DO NOTHING;
