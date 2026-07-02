-- Create horoscopes table
CREATE TABLE IF NOT EXISTS horoscopes (
  id SERIAL PRIMARY KEY,
  type VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create horoscope_history for caching
CREATE TABLE IF NOT EXISTS horoscope_history (
  id SERIAL PRIMARY KEY,
  type VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  date_generated DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(type, date_generated)
);

-- Add horoscope indices
CREATE INDEX IF NOT EXISTS idx_horoscopes_type ON horoscopes(type);
CREATE INDEX IF NOT EXISTS idx_horoscopes_created_at ON horoscopes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_horoscope_history_type_date ON horoscope_history(type, date_generated DESC);

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
    'Professional portfolio platform showcasing projects with AI-generated reports and daily horoscopes',
    ARRAY['React', 'Node.js', 'PostgreSQL', 'Ollama', 'Express.js'],
    'https://github.com/ivanamikush92-dot/Ivana-s-Alchemy',
    'active'
  ),
  (
    'AI Report Generator',
    'Automated system for generating professional project reports and horoscopes using local LLMs',
    ARRAY['Python', 'FastAPI', 'Ollama', 'Docker'],
    'https://github.com/ivanamikush92-dot/reports-generator',
    'active'
  ),
  (
    'Real-time Analytics Dashboard',
    'Live data visualization dashboard for project metrics, horoscope predictions and insights',
    ARRAY['Vue.js', 'WebSocket', 'PostgreSQL', 'D3.js', 'Redis'],
    'https://github.com/ivanamikush92-dot/analytics-dashboard',
    'active'
  )
ON CONFLICT DO NOTHING;

-- Insert initial horoscopes (optional)
INSERT INTO horoscopes (type, content) VALUES
  (
    'daily',
    'היום הוא יום מושלם לתחילות חדשות. האנרגיה שלך גבוהה והמוטיבציה שלך חזקה. בתחום העבודה - ציפו לפתיחות חדשות והזדמנויות בלתי צפויות. בתחום הכלכלי - זהו יום טוב להשקעות חכמות. בתחום הבריאות - שמור על חזות חיובית. מספר המזל שלך היום: 7. צבע המזל: כחול. זכור: אתה יכול להשיג הכל אם תאמין בעצמך!'
  ),
  (
    'weekly',
    'השבוע הנוכחי יהיה מלא בהפתעות חיוביות וסיפוקים אישיים. תהיה לך הזדמנות להשפיע על אחרים ולהראות את יכולתך. זה השבוע המושלם לתכנון ועל לשינויים חיוביים. בתחום הקריירה - מצפים לך הערכות וקידום. בתחום האהבה - יום שלישי יהיה מיוחד. בתחום הכסף - שמור על עמדה שמרנית אך פתוחה. מספר המזל השבועי: 5. צבע המזל: אדום. טיפ: השמע לאינטואיציה שלך!'
  ),
  (
    'monthly',
    'החודש הנוכחי הוא חודש של התחדשות וגדילה אישית. זה התחדשות רוחנית שתוביל אתך למקום חדש וטוב יותר. בתחום הקריירה - צפי לפרויקטים חדשים ותפקידים מרגשים. בתחום הקשרים - יתחזקו הקשרים החשובים לך. בתחום הכלכלה - זהו חודש של יציבות וביטחון. בתחום הבריאות - טיפול עצמי ופעילות גופנית יביאו תוצאות. מספר המזל החודשי: 3. צבע המזל: ירוק. זכור: החודש הזה הוא שלך!'
  )
ON CONFLICT DO NOTHING;
