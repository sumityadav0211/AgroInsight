<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - AgroInsights</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #f5f9f1;
            color: #333;
            line-height: 1.6;
            font-family: 'Poppins', sans-serif;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(rgba(46, 125, 50, 0.9), rgba(27, 94, 32, 0.8)),
            url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            text-align: center;
            padding: 60px 20px;
            border-radius: 0 0 20px 20px;
            margin-bottom: 40px;
        }

        .hero h2 {
            font-size: 36px;
            margin-bottom: 15px;
        }

        .hero p {
            font-size: 18px;
            max-width: 800px;
            margin: 0 auto;
        }

        /* Main Content */
        .main-content {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin-bottom: 50px;
        }

        .contact-info {
            flex: 1;
            min-width: 300px;
            background-color: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .contact-info h3 {
            color: #1b5e20;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .contact-method {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background-color: rgba(76, 175, 80, 0.05);
            border-radius: 10px;
            border: 1px solid rgba(46, 125, 50, 0.1);
        }

        .contact-icon {
            width: 50px;
            height: 50px;
            background-color: rgba(46, 125, 50, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1b5e20;
            font-size: 20px;
        }

        /* Chatbot Section */
        .chatbot-section {
            flex: 2;
            min-width: 300px;
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .chatbot-header {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: white;
            padding: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .chatbot-container {
            height: 500px;
            display: flex;
            flex-direction: column;
        }

        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .message {
            max-width: 80%;
            padding: 15px;
            border-radius: 12px;
        }

        .bot-message {
            background-color: rgba(46, 125, 50, 0.1);
            align-self: flex-start;
            color: #1b5e20;
        }

        .user-message {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: white;
            align-self: flex-end;
        }

        .chat-input-area {
            border-top: 1px solid #eee;
            padding: 15px;
            display: flex;
            gap: 10px;
        }

        .chat-input {
            flex: 1;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        .send-button {
            background: green;
            color: white;
            border: none;
            width: 50px;
            border-radius: 10px;
            cursor: pointer;
        }

        /* Quick Buttons */
        .quick-questions {
            padding: 10px 20px;
            border-top: 1px solid #eee;
        }

        .question-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .question-btn {
            background-color: rgba(46, 125, 50, 0.1);
            border: 1px solid rgba(46, 125, 50, 0.3);
            padding: 8px 15px;
            border-radius: 50px;
            cursor: pointer;
        }

        .question-btn:hover {
            background-color: #2e7d32;
            color: white;
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<section class="hero">
    <div class="container">
        <h2>Contact Us</h2>
        <p>Get support and farming guidance from AgroBot Assistant 🌱</p>
    </div>
</section>

<div class="container">
    <div class="main-content">

        <!-- Contact Info -->
        <div class="contact-info">
            <h3>Your Farm Grow</h3>

            <div class="contact-method">
                <div class="contact-icon"><i class="fas fa-phone-alt"></i></div>
                <p>9495960205</p>
            </div>

            <div class="contact-method">
                <div class="contact-icon"><i class="fas fa-envelope"></i></div>
                <p>support@agroinsights.com</p>
            </div>
        </div>

        <!-- Chatbot -->
        <div class="chatbot-section">

            <div class="chatbot-header">
                <i class="fas fa-robot"></i>
                <h3>AgroBot Assistant</h3>
            </div>

            <div class="chatbot-container">

                <div class="chat-messages" id="chatMessages">
                    <div class="message bot-message">
                        Hello 👋 I’m AgroBot!
                        Ask me about farming or website issues like login, register, crop records.
                    </div>
                </div>

                <!-- Quick Questions -->
                <div class="quick-questions">
                    <h4>Quick Questions:</h4>

                    <div class="question-buttons">
                        <button class="question-btn" onclick="askQuestion('Login issue')">Login Issue</button>
                        <button class="question-btn" onclick="askQuestion('Register problem')">Register Issue</button>
                        <button class="question-btn" onclick="askQuestion('Forgot password')">Forgot Password</button>
                        <button class="question-btn" onclick="askQuestion('Delete crop data')">Delete Data</button>
                        <button class="question-btn" onclick="askQuestion('Move crop data to previous crops')">Move Crop History</button>
                        <button class="question-btn" onclick="askQuestion('Best fertilizers for wheat')">Wheat Fertilizer</button>
                        <button class="question-btn" onclick="askQuestion('Organic pest control')">Pest Control</button>
                        <button class="question-btn" onclick="askQuestion('Contact expert')">Contact Expert</button>
                    </div>
                </div>

                <!-- Input -->
                <div class="chat-input-area">
                    <input type="text" id="userInput" class="chat-input" placeholder="Type your question...">
                    <button class="send-button" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
    const chatMessages = document.getElementById("chatMessages");
    const userInput = document.getElementById("userInput");

    function addMessage(message, isUser) {
        let msgDiv = document.createElement("div");
        msgDiv.className = isUser ? "message user-message" : "message bot-message";
        msgDiv.innerText = message;
        chatMessages.appendChild(msgDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function getAIResponse(userMessage) {

        let msg = userMessage.toLowerCase();

        if (msg.includes("login"))
            return "If you face login issue, check username/password. Use Forgot Password option.";

        if (msg.includes("register"))
            return "For registration issue, fill all fields correctly. Email and mobile must be valid.";

        if (msg.includes("forgot"))
            return "Click Forgot Password on login page. Reset link will be sent to your email.";

        if (msg.includes("delete"))
            return "To delete crop data: Dashboard → Crop Records → Select Crop → Delete.";

        if (msg.includes("previous") || msg.includes("history"))
            return "To move crop data into previous crops: Crop Management → Harvest Completed → Archive Crop.";

        if (msg.includes("fertilizer"))
            return "For wheat: Use urea for nitrogen. Organic option: vermicompost.";

        if (msg.includes("pest"))
            return "Organic pest control: Neem oil spray + marigold companion planting.";

        if (msg.includes("contact"))
            return "Call our expert: 9495960205 or email support@agroinsights.com";

        return "I can help with farming + website support 😊 Please ask clearly!";
    }

    function sendMessage() {
        let message = userInput.value.trim();
        if (message === "") return;

        addMessage(message, true);
        userInput.value = "";

        setTimeout(() => {
            let reply = getAIResponse(message);
            addMessage(reply, false);
        }, 800);
    }

    function askQuestion(question) {
        userInput.value = question;
        sendMessage();
    }
</script>

</body>
</html>
