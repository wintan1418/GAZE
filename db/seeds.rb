# Clear existing data in development
if Rails.env.development?
  puts "🧹 Cleaning existing data..."
  Comment.destroy_all
  EditRequest.destroy_all
  CollectionSnippet.destroy_all
  SnippetTag.destroy_all
  Collection.destroy_all
  Snippet.destroy_all
  Tag.destroy_all
  User.destroy_all
  puts "✅ Data cleared"
end

# Sample code snippets for different languages
SAMPLE_SNIPPETS = {
  javascript: [
    {
      title: "React useState Hook Example",
      description: "Basic example of React useState hook for managing component state",
      code: <<~CODE
        import { useState } from 'react';

        function Counter() {
          const [count, setCount] = useState(0);

          const increment = () => setCount(count + 1);
          const decrement = () => setCount(count - 1);
          const reset = () => setCount(0);

          return (
            <div>
              <h2>Count: {count}</h2>
              <button onClick={increment}>+</button>
              <button onClick={decrement}>-</button>
              <button onClick={reset}>Reset</button>
            </div>
          );
        }

        export default Counter;
      CODE
    },
    {
      title: "Async/Await API Call",
      description: "Clean way to handle API calls using async/await",
      code: <<~CODE
        async function fetchUserData(userId) {
          try {
            const response = await fetch(`/api/users/$\\{userId}`);
            
            if (!response.ok) {
              throw new Error(`HTTP error! status: $\\{response.status}`);
            }
            
            const userData = await response.json();
            return userData;
          } catch (error) {
            console.error('Error fetching user data:', error);
            throw error;
          }
        }

        // Usage
        fetchUserData(123)
          .then(user => console.log(user))
          .catch(error => console.error('Failed:', error));
      CODE
    },
    {
      title: "JavaScript Array Methods Chain",
      description: "Powerful array manipulation using method chaining",
      code: <<~CODE
        const users = [
          { name: 'Alice', age: 30, active: true },
          { name: 'Bob', age: 25, active: false },
          { name: 'Charlie', age: 35, active: true },
          { name: 'Diana', age: 28, active: true }
        ];

        const result = users
          .filter(user => user.active)
          .map(user => (\\{ ...user, ageInMonths: user.age * 12 }))
          .sort((a, b) => b.age - a.age)
          .slice(0, 2);

        console.log(result);
      CODE
    }
  ],
  python: [
    {
      title: "Python List Comprehension Magic",
      description: "Elegant data processing with list comprehensions",
      code: <<~CODE
        # Basic list comprehension
        squares = [x**2 for x in range(10)]
        
        # Conditional list comprehension
        even_squares = [x**2 for x in range(10) if x % 2 == 0]
        
        # Nested list comprehension for matrix operations
        matrix = [[i*j for j in range(3)] for i in range(3)]
        
        # Dictionary comprehension
        word_lengths = \\{word: len(word) for word in ['python', 'java', 'javascript']}
        
        # Set comprehension
        unique_lengths = \\{len(word) for word in ['hello', 'world', 'python']}
        
        print(f"Squares: \\{squares}")
        print(f"Even squares: \\{even_squares}")
        print(f"Matrix: \\{matrix}")
        print(f"Word lengths: \\{word_lengths}")
      CODE
    },
    {
      title: "Flask REST API Endpoint",
      description: "Simple Flask API with error handling and JSON responses",
      code: <<~CODE
        from flask import Flask, request, jsonify
        from functools import wraps
        import jwt

        app = Flask(__name__)
        app.config['SECRET_KEY'] = 'your-secret-key'

        def token_required(f):
            @wraps(f)
            def decorated(*args, **kwargs):
                token = request.headers.get('Authorization')
                if not token:
                    return jsonify(\\{'error': 'Token is missing'}), 401
                try:
                    data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
                except:
                    return jsonify(\\{'error': 'Token is invalid'}), 401
                return f(*args, **kwargs)
            return decorated

        @app.route('/api/users', methods=['GET'])
        @token_required
        def get_users():
            return jsonify(\\{'users': ['Alice', 'Bob', 'Charlie']})

        if __name__ == '__main__':
            app.run(debug=True)
      CODE
    }
  ],
  ruby: [
    {
      title: "Ruby Blocks and Yield",
      description: "Understanding Ruby blocks, procs, and yield keyword",
      code: <<~CODE
        # Method that accepts a block
        def timer
          start_time = Time.now
          result = yield if block_given?
          end_time = Time.now
          puts "Execution time: #\\{end_time - start_time} seconds"
          result
        end

        # Usage with block
        timer do
          sleep(2)
          puts "This took 2 seconds"
        end

        # Method with multiple yield calls
        def repeat(times)
          times.times { |i| yield(i) }
        end

        repeat(3) { |i| puts "Iteration #\\{i + 1}" }

        # Proc example
        multiply_by_two = proc { |x| x * 2 }
        numbers = [1, 2, 3, 4, 5]
        doubled = numbers.map(&multiply_by_two)
        puts doubled
      CODE
    }
  ],
  css: [
    {
      title: "CSS Grid Layout System",
      description: "Modern CSS Grid for responsive layouts",
      code: <<~CODE
        .grid-container {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
          grid-gap: 2rem;
          padding: 2rem;
          max-width: 1200px;
          margin: 0 auto;
        }

        .grid-item {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          border-radius: 12px;
          padding: 2rem;
          color: white;
          box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
          transition: transform 0.3s ease;
        }

        .grid-item:hover {
          transform: translateY(-5px);
          box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        @media (max-width: 768px) {
          .grid-container {
            grid-template-columns: 1fr;
            padding: 1rem;
          }
        }
      CODE
    }
  ],
  html: [
    {
      title: "Semantic HTML5 Structure",
      description: "Proper HTML5 semantic markup for accessibility",
      code: <<~CODE
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Blog Post</title>
        </head>
        <body>
            <header>
                <nav aria-label="Main navigation">
                    <ul>
                        <li><a href="#home">Home</a></li>
                        <li><a href="#about">About</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                </nav>
            </header>

            <main>
                <article>
                    <header>
                        <h1>Understanding Semantic HTML</h1>
                        <time datetime="2024-01-15">January 15, 2024</time>
                    </header>
                    
                    <section>
                        <h2>What is Semantic HTML?</h2>
                        <p>Semantic HTML uses meaningful tags...</p>
                    </section>
                </article>

                <aside>
                    <h3>Related Articles</h3>
                    <ul>
                        <li><a href="#">HTML Best Practices</a></li>
                        <li><a href="#">Accessibility Guide</a></li>
                    </ul>
                </aside>
            </main>

            <footer>
                <p>&copy; 2024 My Blog. All rights reserved.</p>
            </footer>
        </body>
        </html>
      CODE
    }
  ],
  sql: [
    {
      title: "Complex SQL Query with CTEs",
      description: "Using Common Table Expressions for complex data analysis",
      code: <<~CODE
        WITH monthly_sales AS (
          SELECT 
            DATE_TRUNC('month', order_date) as month,
            SUM(amount) as total_sales,
            COUNT(*) as order_count
          FROM orders 
          WHERE order_date >= '2023-01-01'
          GROUP BY DATE_TRUNC('month', order_date)
        ),
        sales_with_growth AS (
          SELECT 
            month,
            total_sales,
            order_count,
            LAG(total_sales) OVER (ORDER BY month) as prev_month_sales,
            total_sales - LAG(total_sales) OVER (ORDER BY month) as growth
          FROM monthly_sales
        )
        SELECT 
          month,
          total_sales,
          order_count,
          growth,
          CASE 
            WHEN prev_month_sales > 0 THEN 
              ROUND((growth / prev_month_sales) * 100, 2) 
            ELSE NULL 
          END as growth_percentage
        FROM sales_with_growth
        ORDER BY month;
      CODE
    }
  ]
}

# Create diverse users
puts "👥 Creating users..."

users_data = [
  { username: "alexcoder", name: "Alex Johnson", email: "alex@example.com", bio: "Full-stack developer passionate about React and Node.js" },
  { username: "rubymage", name: "Sarah Chen", email: "sarah@example.com", bio: "Ruby on Rails enthusiast and open source contributor" },
  { username: "pythonista", name: "Miguel Rodriguez", email: "miguel@example.com", bio: "Data scientist and Python developer" },
  { username: "jsninjas", name: "Emma Wilson", email: "emma@example.com", bio: "Frontend developer specializing in modern JavaScript" },
  { username: "devops_pro", name: "David Kim", email: "david@example.com", bio: "DevOps engineer with expertise in Docker and Kubernetes" },
  { username: "mobile_dev", name: "Lisa Thompson", email: "lisa@example.com", bio: "Mobile app developer for iOS and Android" },
  { username: "ai_researcher", name: "Prof. James Wright", email: "james@example.com", bio: "AI/ML researcher and university professor" },
  { username: "web_designer", name: "Anna Kowalski", email: "anna@example.com", bio: "UI/UX designer who codes" },
  { username: "backend_guru", name: "Carlos Santos", email: "carlos@example.com", bio: "Backend architect with 15+ years experience" },
  { username: "startup_cto", name: "Rachel Green", email: "rachel@example.com", bio: "CTO at a fintech startup" },
  { username: "freelancer", name: "Tom Anderson", email: "tom@example.com", bio: "Full-stack freelancer" },
  { username: "gamedev", name: "Kenji Nakamura", email: "kenji@example.com", bio: "Game developer and Unity expert" },
  { username: "security_expert", name: "Maria Gonzalez", email: "maria@example.com", bio: "Cybersecurity specialist" },
  { username: "database_admin", name: "Robert Lee", email: "robert@example.com", bio: "Database administrator and SQL expert" },
  { username: "cloud_architect", name: "Jennifer Brown", email: "jennifer@example.com", bio: "AWS certified cloud architect" },
  { username: "junior_dev", name: "Chris Miller", email: "chris@example.com", bio: "Recent bootcamp graduate" },
  { username: "senior_dev", name: "Patricia Davis", email: "patricia@example.com", bio: "Senior software engineer" },
  { username: "tech_lead", name: "Michael Johnson", email: "michael@example.com", bio: "Tech lead at FAANG company" },
  { username: "consultant", name: "Sandra Wilson", email: "sandra@example.com", bio: "Technical consultant" },
  { username: "educator", name: "Dr. Kevin Brown", email: "kevin@example.com", bio: "Computer science educator" }
]

# Create 50+ more diverse users
30.times do |i|
  users_data << {
    username: "developer#{i + 21}",
    name: "Developer #{i + 21}",
    email: "dev#{i + 21}@example.com",
    bio: ["Code enthusiast", "Problem solver", "Tech lover", "Algorithm expert", "Software crafter"].sample
  }
end

users = []
users_data.each do |user_data|
  user = User.create!(
    username: user_data[:username],
    name: user_data[:name],
    email: user_data[:email],
    bio: user_data[:bio],
    password: "password123",
    password_confirmation: "password123"
  )
  users << user
  print "."
end

puts "\\n✅ Created #\\{users.length} users"

# Create diverse tags
puts "🏷️ Creating tags..."
tag_data = [
  { name: "react", color: "#61dafb" },
  { name: "javascript", color: "#f7df1e" },
  { name: "python", color: "#3776ab" },
  { name: "ruby", color: "#cc342d" },
  { name: "rails", color: "#cc0000" },
  { name: "nodejs", color: "#339933" },
  { name: "typescript", color: "#3178c6" },
  { name: "vue", color: "#4fc08d" },
  { name: "angular", color: "#dd0031" },
  { name: "css", color: "#1572b6" },
  { name: "html", color: "#e34f26" },
  { name: "sql", color: "#4479a1" },
  { name: "docker", color: "#2496ed" },
  { name: "kubernetes", color: "#326ce5" },
  { name: "aws", color: "#ff9900" },
  { name: "algorithms", color: "#ff6b6b" },
  { name: "datastructures", color: "#4ecdc4" },
  { name: "api", color: "#45b7d1" },
  { name: "frontend", color: "#ff9f43" },
  { name: "backend", color: "#6c5ce7" },
  { name: "fullstack", color: "#a29bfe" },
  { name: "mobile", color: "#fd79a8" },
  { name: "testing", color: "#00b894" },
  { name: "performance", color: "#e17055" },
  { name: "security", color: "#2d3436" }
]

# Create snippets with realistic content
puts "📝 Creating snippets..."
snippet_count = 0

users.each_with_index do |user, user_index|
  # Each user creates 2-8 snippets
  num_snippets = rand(2..8)
  
  num_snippets.times do
    language = SAMPLE_SNIPPETS.keys.sample
    snippet_data = SAMPLE_SNIPPETS[language].sample
    
    if snippet_data.nil?
      # Generate a simple snippet if no sample available
      snippet_data = {
        title: "#\\{language.to_s.capitalize} Code Example",
        description: "A useful #\\{language} code snippet",
        code: "// #\\{language.to_s.capitalize} code example\\nconsole.log('Hello, World!');"
      }
    end
    
    snippet = user.snippets.create!(
      title: "#{snippet_data[:title]} - #{user.username}",
      description: snippet_data[:description],
      code: snippet_data[:code],
      language: language.to_s,
      visibility: [0, 1].sample, # Mix of private and public
      view_count: rand(0..1000),
      copy_count: rand(0..200)
    )
    
    # Add random tags (1-4 per snippet)
    available_tags = tag_data.sample(rand(1..4))
    available_tags.each do |tag_info|
      tag = user.tags.find_or_create_by(name: tag_info[:name]) do |t|
        t.color = tag_info[:color]
      end
      snippet.tags << tag unless snippet.tags.include?(tag)
    end
    
    snippet_count += 1
    print "."
  end
end

puts "\\n✅ Created #\\{snippet_count} snippets"

# Create collections
puts "📁 Creating collections..."
users.sample(30).each do |user|
  rand(1..3).times do
    collection_name = ["My Best Snippets", "Frontend Utils", "Backend Tools", "API Helpers", "Quick Scripts", "Algorithms", "Data Processing", "UI Components"].sample
    collection = user.collections.create!(
      name: "#{collection_name} - #{user.username}",
      description: "A curated collection of useful code snippets",
      visibility: [0, 1].sample
    )
    
    # Add 2-6 snippets to each collection
    user.snippets.sample(rand(2..6)).each do |snippet|
      collection.snippets << snippet unless collection.snippets.include?(snippet)
    end
  end
  print "."
end

puts "\\n✅ Created collections"

# Create comments on public snippets
puts "💬 Creating comments..."
public_snippets = Snippet.where(visibility: 1).limit(100)
comment_count = 0

public_snippets.each do |snippet|
  # Random number of comments per snippet (0-10)
  rand(0..10).times do
    commenter = users.sample
    next if commenter == snippet.user # Don't comment on own snippets
    
    comments_text = [
      "Great snippet! Thanks for sharing.",
      "This is exactly what I was looking for.",
      "Nice implementation, very clean code.",
      "Could you explain how this works?",
      "I've been using this approach, works great!",
      "Excellent example, very helpful.",
      "This saved me hours of work, thank you!",
      "Love the elegant solution here.",
      "Would this work with the latest version?",
      "Perfect timing, needed this for my project."
    ]
    
    snippet.comments.create!(
      user: commenter,
      content: comments_text.sample,
      created_at: rand(30.days).seconds.ago
    )
    comment_count += 1
  end
  print "."
end

puts "\\n✅ Created #\\{comment_count} comments"

# Create some edit requests
puts "🤝 Creating edit requests..."
edit_request_count = 0

public_snippets.sample(50).each do |snippet|
  requester = users.sample
  next if requester == snippet.user # Can't request edit on own snippet
  
  # Skip if already has a request
  next if snippet.edit_requests.where(requester: requester).exists?
  
  messages = [
    "Hi! I'd love to add error handling to this snippet. Could I help improve it?",
    "Great code! I have some optimization ideas I'd like to contribute.",
    "Would you mind if I added TypeScript types to this?",
    "I noticed a small bug and would like to fix it if that's okay.",
    "Could I add some documentation comments to make this more clear?"
  ]
  
  status = ['pending', 'approved', 'denied'].sample
  
  edit_request = snippet.edit_requests.create!(
    requester: requester,
    message: messages.sample,
    status: status,
    approver: status != 'pending' ? snippet.user : nil,
    created_at: rand(7.days).seconds.ago
  )
  
  edit_request_count += 1
  print "."
end

puts "\\n✅ Created #\\{edit_request_count} edit requests"

# Create some stars for snippets
puts "⭐ Creating stars..."
star_count = 0

public_snippets.sample(80).each do |snippet|
  # Each snippet gets starred by 1-15 random users
  users.sample(rand(1..15)).each do |user|
    next if user == snippet.user # Don't star own snippets
    
    # Skip if already starred
    next if snippet.stars.where(user: user).exists?
    
    snippet.stars.create!(
      user: user,
      created_at: rand(30.days).seconds.ago
    )
    star_count += 1
  end
  print "."
end

puts "\\n✅ Created #\\{star_count} stars"

# Create Stacks
puts "\\n🗂️  Creating stacks..."
stack_count = 0

users.each do |user|
  rand(0..3).times do
    stack = user.stacks.create!(
      name: [
        "Web Development Essentials",
        "React Best Practices",
        "Python Utilities",
        "Database Queries",
        "DevOps Scripts",
        "Algorithm Collection",
        "API Integration",
        "Testing Helpers",
        "CSS Animations",
        "JavaScript Tricks"
      ].sample,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      visibility: [:private_stack, :public_stack].sample,
      color: ["#3B82F6", "#10B981", "#F59E0B", "#EF4444", "#8B5CF6", "#EC4899", "#14B8A6"].sample
    )
    
    # Add random snippets to stack
    user_snippets = user.snippets.to_a
    if user_snippets.any?
      rand(2..5).times do
        snippet = user_snippets.sample
        unless stack.snippets.exists?(snippet.id)
          stack.snippets << snippet
        end
      end
    end
    
    stack_count += 1
    print "."
  end
end

puts "\\n✅ Created #\\{stack_count} stacks"

puts "\\n🎉 Seeding completed successfully!"
puts "📊 Summary:"
puts "  👥 Users: #\\{User.count}"
puts "  📝 Snippets: #\\{Snippet.count} (#\\{Snippet.where(visibility: 1).count} public)"
puts "  🏷️ Tags: #\\{Tag.count}"
puts "  📁 Collections: #\\{Collection.count}"
puts "  💬 Comments: #\\{Comment.count}"
puts "  🤝 Edit Requests: #\\{EditRequest.count}"
puts "  ⭐ Stars: #\\{Star.count}"
puts "  🗂️  Stacks: #\\{Stack.count} (#\\{Stack.where(visibility: 1).count} public)"
puts "\\n🚀 Your GAZE platform is now populated with realistic data!"