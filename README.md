# 🧪 Ivana's Alchemy - Professional Portfolio Generator

AI-powered professional portfolio platform that automatically generates high-quality project reports using local LLMs.

## ✨ Features

- 🤖 **AI-Powered Reports** - Generate professional project descriptions using Ollama (local, free)
- 📊 **Beautiful UI** - Modern, responsive interface with Tailwind CSS
- 🗄️ **PostgreSQL Database** - Persistent storage for projects and reports
- 🚀 **Fast & Scalable** - Built with Express.js and Node.js
- 🔒 **Privacy First** - No external APIs, everything runs locally
- 📱 **Fully Responsive** - Works on desktop, tablet, and mobile

## 🛠️ Tech Stack

- **Backend**: Node.js + Express.js
- **Database**: PostgreSQL
- **AI Engine**: Ollama (Mistral LLM)
- **Frontend**: HTML5 + Vanilla JavaScript
- **Deployment**: Render.com / Railway / Self-hosted

## 📋 Prerequisites

1. **Node.js** (v16+)
   ```bash
   # Check version
   node --version
   ```

2. **PostgreSQL** (v12+)
   ```bash
   # Check version
   psql --version
   ```

3. **Ollama** (Local AI)
   ```bash
   # Download from ollama.ai
   # macOS: brew install ollama
   # Linux: curl https://ollama.ai/install.sh | sh
   ```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/ivanamikush92-dot/Ivana-s-Alchemy.git
cd Ivana-s-Alchemy
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Setup Environment Variables
```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```
DATABASE_URL=postgresql://user:password@localhost:5432/ivanas_alchemy
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=mistral
PORT=3000
NODE_ENV=development
```

### 4. Setup Database
```bash
# Create database
createdb ivanas_alchemy

# Run initialization script
psql -U postgres -d ivanas_alchemy -f db-init.sql
```

### 5. Start Ollama
```bash
# In a new terminal
ollama serve

# In another terminal, download the model
ollama pull mistral
# or: ollama pull neural-chat (smaller, faster)
```

### 6. Start the Server
```bash
npm start
# or for development with auto-reload:
npm run dev
```

### 7. Open in Browser
Visit: **http://localhost:3000**

## 📝 Usage

1. **Add Projects** (Optional - samples included)
   ```bash
   curl -X POST http://localhost:3000/api/projects \
     -H "Content-Type: application/json" \
     -d '{
       "name": "My Project",
       "description": "Project description",
       "technologies": ["React", "Node.js"],
       "github_url": "https://github.com/..."
     }'
   ```

2. **Generate Reports**
   - Click "🚀 Generate AI Reports" button in the UI
   - Wait for reports to be generated (1-2 minutes)
   - Reports will automatically display

3. **View Reports**
   - Reports are displayed on the main page
   - Each report includes project title and AI-generated professional description

## 📚 API Endpoints

### Projects
- `GET /api/projects` - List all active projects
- `POST /api/projects` - Create new project

### Reports
- `GET /api/reports` - Get all generated reports
- `POST /api/generate-reports` - Generate reports for all projects

### Health
- `GET /api/health` - Server health check

## 🗄️ Database Schema

### Projects Table
```sql
- id (SERIAL PRIMARY KEY)
- name (VARCHAR UNIQUE)
- description (TEXT)
- technologies (TEXT[])
- image_url (VARCHAR)
- github_url (VARCHAR)
- live_url (VARCHAR)
- status (VARCHAR)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

### Reports Table
```sql
- id (SERIAL PRIMARY KEY)
- project_id (INTEGER FK)
- title (VARCHAR)
- content (TEXT)
- summary (VARCHAR)
- generated_at (TIMESTAMP)
```

## 🎨 Customization

### Change AI Model
Edit `OLLAMA_MODEL` in `.env`:
- `mistral` - Fast, good quality (recommended)
- `neural-chat` - Smaller, very fast
- `llama2` - Larger, higher quality
- `dolphin-mixtral` - Advanced, larger

### Change Styling
Edit colors in `public/index.html`:
```css
:root {
  --primary: #667eea;
  --secondary: #764ba2;
  --success: #48bb78;
}
```

## 🚀 Deployment

### Deploy on Render.com
1. Push to GitHub
2. Connect repository to Render
3. Add environment variables
4. Deploy with PostgreSQL add-on
5. Run migrations

### Deploy on Railway
1. Connect GitHub repo
2. Add PostgreSQL plugin
3. Set environment variables
4. Deploy

### Self-hosted with Docker
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## 📊 Performance Tips

1. **Use smaller models** for faster generation
2. **Increase RAM** for better model performance
3. **Run Ollama on GPU** for significant speedup
4. **Cache reports** to avoid regeneration

## 🔧 Troubleshooting

### "Cannot connect to database"
```bash
# Check PostgreSQL is running
psql -U postgres

# Verify DATABASE_URL is correct
echo $DATABASE_URL
```

### "Ollama connection refused"
```bash
# Make sure Ollama is running
ollama serve

# Check if port 11434 is accessible
curl http://localhost:11434/api/health
```

### "No reports generated"
1. Verify projects exist in database
2. Check server logs for errors
3. Ensure Ollama model is downloaded
4. Check API is responding: `http://localhost:3000/api/health`

## 📄 License

MIT - Feel free to use and modify

## 🤝 Contributing

Contributions welcome! Feel free to open issues and pull requests.

## 📧 Contact

**Ivana** - [@ivanamikush92-dot](https://github.com/ivanamikush92-dot)
- 🌐 Portfolio: [ivanasalchemy.online](https://ivanasalchemy.online)
- 💼 GitHub: [github.com/ivanamikush92-dot](https://github.com/ivanamikush92-dot)

---

Made with ❤️ and AI magic 🧪✨
