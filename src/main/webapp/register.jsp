<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgroInsights - Login & Register</title>

    <!-- Box Icons -->
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        :root {
            --primary: #1b5e20;
            --primary-dark: #0f3b1a;
            --primary-light: #2e7d32;
            --accent: #ffb74d;
            --accent-dark: #ff9800;
            --error: #ff4444;
            --success: #4CAF50;
            --warning: #ffb74d;
            --info: #2196F3;
        }

        /* Base font size that scales with viewport */
        html {
            font-size: 16px;
        }

        @media screen and (max-width: 1200px) {
            html {
                font-size: 15px;
            }
        }

        @media screen and (max-width: 992px) {
            html {
                font-size: 14px;
            }
        }

        @media screen and (max-width: 768px) {
            html {
                font-size: 13px;
            }
        }

        @media screen and (max-width: 576px) {
            html {
                font-size: 12px;
            }
        }

        @media screen and (max-width: 400px) {
            html {
                font-size: 11px;
            }
        }

        body {
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80') no-repeat center center fixed;
            background-size: cover;
            position: relative;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(0, 40, 0, 0.7) 0%, rgba(0, 60, 0, 0.5) 50%, rgba(0, 30, 0, 0.7) 100%);
            z-index: -1;
        }

        /* Toast Notification System - Modern Design */
        .toast-container {
            position: fixed;
            top: 120px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-width: 350px;
            width: 100%;
            pointer-events: none;
        }

        @media screen and (max-width: 768px) {
            .toast-container {
                top: 100px;
                right: 10px;
                left: 10px;
                max-width: 100%;
                width: auto;
            }
        }

        .toast {
            background: white;
            border-radius: 16px;
            padding: 1rem 1.2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 183, 77, 0.2);
            display: flex;
            align-items: center;
            gap: 1rem;
            transform: translateX(400px);
            opacity: 0;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            position: relative;
            overflow: hidden;
            pointer-events: auto;
            border-left: 5px solid;
            backdrop-filter: blur(10px);
        }

        .toast.show {
            transform: translateX(0);
            opacity: 1;
        }

        .toast.error {
            background: rgba(255, 245, 245, 0.95);
            border-left-color: var(--error);
        }

        .toast.success {
            background: rgba(245, 255, 245, 0.95);
            border-left-color: var(--success);
        }

        .toast.warning {
            background: rgba(255, 250, 235, 0.95);
            border-left-color: var(--warning);
        }

        .toast.info {
            background: rgba(235, 245, 255, 0.95);
            border-left-color: var(--info);
        }

        .toast-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .toast.error .toast-icon {
            background: rgba(255, 68, 68, 0.15);
            color: var(--error);
        }

        .toast.success .toast-icon {
            background: rgba(76, 175, 80, 0.15);
            color: var(--success);
        }

        .toast.warning .toast-icon {
            background: rgba(255, 183, 77, 0.15);
            color: var(--warning);
        }

        .toast.info .toast-icon {
            background: rgba(33, 150, 243, 0.15);
            color: var(--info);
        }

        .toast-content {
            flex: 1;
        }

        .toast-title {
            font-weight: 700;
            font-size: 1rem;
            color: #333;
            margin-bottom: 0.2rem;
        }

        .toast-message {
            font-size: 0.9rem;
            color: #666;
            line-height: 1.4;
        }

        .toast-close {
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 1.2rem;
            padding: 0.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            border-radius: 50%;
            width: 30px;
            height: 30px;
        }

        .toast-close:hover {
            background: rgba(0, 0, 0, 0.05);
            color: #333;
        }

        .toast-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent), var(--accent-dark));
            width: 100%;
            transform: scaleX(1);
            transform-origin: left;
            transition: transform 3s linear;
        }

        .toast.error .toast-progress {
            background: linear-gradient(90deg, var(--error), #ff6b6b);
        }

        .toast.success .toast-progress {
            background: linear-gradient(90deg, var(--success), #8BC34A);
        }

        .toast.warning .toast-progress {
            background: linear-gradient(90deg, var(--warning), var(--accent-dark));
        }

        .toast.info .toast-progress {
            background: linear-gradient(90deg, var(--info), #64B5F6);
        }

        /* Floating particles effect */
        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" opacity="0.1"><circle cx="10" cy="10" r="2" fill="white"/><circle cx="90" cy="30" r="3" fill="white"/><circle cx="30" cy="80" r="2" fill="white"/><circle cx="70" cy="60" r="4" fill="white"/><circle cx="50" cy="20" r="2" fill="white"/></svg>');
            background-size: 200px 200px;
            pointer-events: none;
            animation: floatParticles 20s linear infinite;
            z-index: -1;
        }

        @keyframes floatParticles {
            0% { transform: translateY(0) rotate(0deg); }
            100% { transform: translateY(-100px) rotate(10deg); }
        }

        /* Location Bar */
        .location-bar {
            background: linear-gradient(135deg, #1e4a1e 0%, #2e7d32 100%);
            backdrop-filter: blur(10px);
            padding: 0.7rem 2rem;
            position: fixed;
            width: 100%;
            top: 85px;
            z-index: 999;
            border-bottom: 2px solid var(--accent);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }

        @media screen and (max-width: 768px) {
            .location-bar {
                padding: 0.5rem 1rem;
            }
        }

        @media screen and (max-width: 480px) {
            .location-bar {
                padding: 0.4rem 0.8rem;
                top: 70px;
            }
        }

        .location-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            font-size: clamp(0.8rem, 2vw, 0.95rem);
        }

        @media screen and (max-width: 900px) {
            .location-container {
                flex-wrap: wrap;
                gap: 0.5rem;
                justify-content: center;
            }
        }

        .location {
            display: flex;
            align-items: center;
            gap: clamp(0.3rem, 1.5vw, 0.5rem);
            background: rgba(255, 255, 255, 0.15);
            padding: clamp(0.3rem, 1.5vw, 0.4rem) clamp(0.8rem, 2vw, 1.2rem);
            border-radius: 40px;
            border: 1px solid rgba(255, 183, 77, 0.3);
            white-space: nowrap;
        }

        @media screen and (max-width: 600px) {
            .location {
                white-space: normal;
                text-align: center;
                flex-wrap: wrap;
                justify-content: center;
            }
        }

        .location i {
            color: var(--accent);
            font-size: clamp(1rem, 2.5vw, 1.2rem);
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
        }

        .location span {
            font-weight: 500;
            font-size: clamp(0.8rem, 2vw, 1rem);
        }

        .location .loading {
            opacity: 0.8;
            font-size: clamp(0.7rem, 1.8vw, 0.85rem);
            margin-left: clamp(0.3rem, 1vw, 0.5rem);
            animation: pulse 1.5s infinite;
            color: var(--accent);
        }

        .live-updates {
            display: flex;
            align-items: center;
            gap: clamp(0.8rem, 2vw, 1.5rem);
            flex-wrap: wrap;
        }

        @media screen and (max-width: 700px) {
            .live-updates {
                justify-content: center;
                gap: 0.8rem;
            }
        }

        .live-badge {
            background: linear-gradient(135deg, var(--error), #ff6b6b);
            color: white;
            padding: clamp(0.2rem, 1vw, 0.3rem) clamp(0.6rem, 2vw, 1rem);
            border-radius: 20px;
            font-size: clamp(0.7rem, 1.8vw, 0.8rem);
            font-weight: 600;
            animation: pulse 2s infinite;
            box-shadow: 0 0 15px rgba(255, 68, 68, 0.5);
            white-space: nowrap;
        }

        .datetime {
            display: flex;
            align-items: center;
            gap: clamp(0.3rem, 1vw, 0.5rem);
            background: rgba(0, 0, 0, 0.2);
            padding: clamp(0.2rem, 1vw, 0.3rem) clamp(0.8rem, 2vw, 1.2rem);
            border-radius: 30px;
            white-space: nowrap;
        }

        @media screen and (max-width: 550px) {
            .datetime {
                white-space: normal;
                text-align: center;
            }
        }

        .datetime i {
            color: var(--accent);
            font-size: clamp(0.9rem, 2.2vw, 1.1rem);
        }

        .datetime span {
            font-size: clamp(0.7rem, 1.8vw, 0.9rem);
        }

        .live-text {
            color: var(--accent);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: clamp(0.2rem, 1vw, 0.3rem);
            background: rgba(0, 0, 0, 0.2);
            padding: clamp(0.2rem, 1vw, 0.3rem) clamp(0.8rem, 2vw, 1.2rem);
            border-radius: 30px;
            border: 1px solid var(--accent);
            white-space: nowrap;
            font-size: clamp(0.7rem, 1.8vw, 0.9rem);
        }

        @media screen and (max-width: 500px) {
            .live-text {
                white-space: normal;
            }
        }

        @keyframes pulse {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.6; transform: scale(0.98); }
            100% { opacity: 1; transform: scale(1); }
        }

        /* Main Container */
        .main-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: clamp(8rem, 15vh, 10rem) clamp(1rem, 3vw, 2rem) clamp(1rem, 3vw, 2rem);
        }

        .glass-container {
            max-width: 1200px;
            width: 100%;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: clamp(30px, 5vw, 50px);
            padding: clamp(1.5rem, 4vw, 3rem);
            box-shadow: 0 30px 60px rgba(0, 40, 0, 0.5), 0 0 0 1px rgba(255, 183, 77, 0.2) inset;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 40px 80px rgba(0, 60, 0, 0.6);
        }

        .content-wrapper {
            display: flex;
            gap: clamp(1.5rem, 4vw, 3rem);
            align-items: center;
        }

        /* Left Content */
        .left-content {
            flex: 1;
            color: white;
            position: relative;
        }

        .left-content::before {
            content: '🌾';
            position: absolute;
            top: -20px;
            left: -20px;
            font-size: clamp(2rem, 6vw, 4rem);
            opacity: 0.2;
            transform: rotate(-15deg);
            animation: floatIcon 6s ease-in-out infinite;
        }

        .left-content::after {
            content: '🚜';
            position: absolute;
            bottom: -20px;
            right: -20px;
            font-size: clamp(2rem, 6vw, 4rem);
            opacity: 0.2;
            transform: rotate(10deg);
            animation: floatIcon 8s ease-in-out infinite reverse;
        }

        @keyframes floatIcon {
            0%, 100% { transform: translateY(0) rotate(-15deg); }
            50% { transform: translateY(-20px) rotate(-10deg); }
        }

        .left-content h1 {
            font-size: clamp(2rem, 6vw, 3.2rem);
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.4);
            background: linear-gradient(135deg, #ffffff, var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: glow 3s ease-in-out infinite;
        }

        @keyframes glow {
            0%, 100% { text-shadow: 0 0 20px rgba(255, 183, 77, 0.3); }
            50% { text-shadow: 0 0 40px rgba(255, 183, 77, 0.6); }
        }

        .left-content p {
            font-size: clamp(0.9rem, 2.2vw, 1.1rem);
            opacity: 0.95;
            margin-bottom: 2rem;
            line-height: 1.6;
            max-width: 500px;
            background: rgba(0, 0, 0, 0.2);
            padding: clamp(0.8rem, 2vw, 1rem) clamp(1rem, 2.5vw, 1.5rem);
            border-radius: 20px;
            backdrop-filter: blur(5px);
            border-left: 4px solid var(--accent);
        }

        .feature-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: clamp(0.5rem, 1.5vw, 1rem);
            background: rgba(255, 255, 255, 0.15);
            padding: clamp(0.5rem, 1.5vw, 0.8rem) clamp(1rem, 2.5vw, 1.5rem);
            border-radius: 50px;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 183, 77, 0.3);
            transition: all 0.3s ease;
            width: fit-content;
            max-width: 100%;
        }

        @media screen and (max-width: 768px) {
            .feature-item {
                width: 100%;
                justify-content: center;
            }
        }

        .feature-item:hover {
            transform: translateX(15px);
            background: rgba(255, 183, 77, 0.2);
            border-color: var(--accent);
            box-shadow: 0 5px 20px rgba(255, 183, 77, 0.3);
        }

        .feature-item i {
            font-size: clamp(1.2rem, 2.5vw, 1.5rem);
            color: var(--accent);
            background: rgba(0, 0, 0, 0.3);
            padding: clamp(0.3rem, 1vw, 0.5rem);
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .feature-item:hover i {
            transform: rotate(360deg);
            background: var(--accent);
            color: #1e4a1e;
        }

        .feature-item span {
            font-size: clamp(0.8rem, 2vw, 1rem);
            font-weight: 500;
        }

        /* Form Container */
        .form-container {
            flex: 0.9;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: clamp(25px, 4vw, 40px);
            padding: clamp(1.5rem, 4vw, 2.5rem);
            box-shadow: 0 30px 50px rgba(0, 30, 0, 0.4);
            border: 1px solid rgba(255, 183, 77, 0.3);
            position: relative;
            overflow: hidden;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: clamp(150px, 30vw, 200px);
            height: clamp(150px, 30vw, 200px);
            background: radial-gradient(circle, rgba(255,183,77,0.2) 0%, transparent 70%);
            border-radius: 50%;
            animation: rotateGlow 15s linear infinite;
        }

        .form-container::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -50%;
            width: clamp(200px, 40vw, 300px);
            height: clamp(200px, 40vw, 300px);
            background: radial-gradient(circle, rgba(46,125,50,0.2) 0%, transparent 70%);
            border-radius: 50%;
            animation: rotateGlow 20s linear infinite reverse;
        }

        @keyframes rotateGlow {
            0% { transform: rotate(0deg) scale(1); }
            50% { transform: rotate(180deg) scale(1.2); }
            100% { transform: rotate(360deg) scale(1); }
        }

        .form-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            background: rgba(241, 245, 249, 0.9);
            padding: 0.5rem;
            border-radius: 50px;
            position: relative;
            z-index: 1;
        }

        .tab-btn {
            flex: 1;
            background: none;
            border: none;
            padding: clamp(0.5rem, 2vw, 0.8rem) clamp(0.6rem, 2vw, 1rem);
            font-size: clamp(0.8rem, 2vw, 1rem);
            font-weight: 600;
            color: #2e5e2e;
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: 50px;
            position: relative;
            overflow: hidden;
        }

        .tab-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 183, 77, 0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .tab-btn:hover::before {
            width: 200px;
            height: 200px;
        }

        .tab-btn.active {
            background: linear-gradient(135deg, #ffffff, #f0f7f0);
            color: var(--primary);
            box-shadow: 0 8px 20px rgba(27, 94, 32, 0.2);
            border: 1px solid var(--accent);
        }

        .form-panel {
            display: none;
            position: relative;
            z-index: 1;
        }

        .form-panel.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-panel h2 {
            font-size: clamp(1.5rem, 4vw, 2rem);
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
            position: relative;
            display: inline-block;
        }

        .form-panel h2::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: clamp(30px, 8vw, 50px);
            height: 3px;
            background: linear-gradient(90deg, var(--accent), transparent);
            border-radius: 2px;
        }

        .form-subtitle {
            color: #4a6b4a;
            margin-bottom: 2rem;
            font-size: clamp(0.8rem, 2vw, 0.95rem);
            padding-left: 0.5rem;
            border-left: 3px solid var(--accent);
        }

        .input-box {
            position: relative;
            margin: clamp(1rem, 2.5vw, 1.5rem) 0;
            transition: transform 0.3s ease;
        }

        .input-box input {
            width: 100%;
            padding: clamp(0.8rem, 2vw, 1rem) clamp(0.8rem, 2vw, 1rem) clamp(0.8rem, 2vw, 1rem) clamp(2.5rem, 5vw, 3rem);
            background: #ffffff;
            border: 2px solid #e0f0e0;
            border-radius: clamp(10px, 2vw, 15px);
            outline: none;
            font-size: clamp(0.85rem, 2vw, 0.95rem);
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);
        }

        .input-box input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 4px rgba(255, 183, 77, 0.15), 0 5px 15px rgba(0, 30, 0, 0.1);
            transform: translateY(-2px);
        }

        .input-box input.error {
            border-color: var(--error);
            background: #fff5f5;
            animation: shake 0.3s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .input-box i {
            position: absolute;
            left: clamp(0.8rem, 2vw, 1rem);
            top: 50%;
            transform: translateY(-50%);
            font-size: clamp(1rem, 2.2vw, 1.2rem);
            color: var(--accent);
            transition: all 0.3s ease;
            z-index: 2;
        }

        .input-box input.error + i {
            color: var(--error);
        }

        .input-box input:focus + i {
            color: var(--primary);
            transform: translateY(-50%) scale(1.1);
        }

        .forgot-link {
            text-align: right;
            margin: -0.5rem 0 1.5rem;
        }

        .forgot-link a {
            color: #4a6b4a;
            text-decoration: none;
            font-size: clamp(0.8rem, 2vw, 0.9rem);
            transition: all 0.3s ease;
            position: relative;
        }

        .forgot-link a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 1px;
            background: var(--accent);
            transition: width 0.3s ease;
        }

        .forgot-link a:hover {
            color: var(--accent);
        }

        .forgot-link a:hover::after {
            width: 100%;
        }

        .submit-btn {
            width: 100%;
            padding: clamp(0.8rem, 2vw, 1rem);
            background: linear-gradient(135deg, var(--primary), var(--primary-light), var(--primary));
            background-size: 200% 200%;
            border: none;
            border-radius: clamp(10px, 2vw, 15px);
            color: white;
            font-size: clamp(0.9rem, 2.2vw, 1rem);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            position: relative;
            overflow: hidden;
            animation: gradientShift 5s ease infinite;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .submit-btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 30px rgba(27, 94, 32, 0.4);
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }

        .divider {
            position: relative;
            text-align: center;
            margin: 1.5rem 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: clamp(35%, 40vw, 45%);
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent), transparent);
        }

        .divider::before {
            left: 0;
        }

        .divider::after {
            right: 0;
        }

        .divider span {
            background: white;
            padding: 0 clamp(0.8rem, 2.5vw, 1.5rem);
            color: var(--primary);
            font-size: clamp(0.8rem, 2vw, 0.9rem);
            font-weight: 500;
            border-radius: 20px;
            border: 1px solid var(--accent);
            display: inline-block;
        }

        .social-icons {
            display: flex;
            justify-content: center;
            gap: clamp(0.8rem, 2vw, 1.2rem);
            flex-wrap: wrap;
        }

        .social-icons a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: clamp(40px, 8vw, 50px);
            height: clamp(40px, 8vw, 50px);
            background: white;
            border: 2px solid #e0f0e0;
            border-radius: 50%;
            color: var(--primary-light);
            font-size: clamp(1.1rem, 2.5vw, 1.3rem);
            text-decoration: none;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .social-icons a::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            border-radius: 50%;
            transform: scale(0);
            transition: transform 0.4s ease;
            z-index: -1;
        }

        .social-icons a:hover {
            color: white;
            border-color: var(--accent);
            transform: translateY(-5px) rotate(360deg);
        }

        .social-icons a:hover::before {
            transform: scale(1);
        }

        /* Bottom Quote */
        .bottom-quote {
            margin-top: 2rem;
            text-align: center;
            color: rgba(255, 255, 255, 0.95);
            font-size: clamp(0.85rem, 2.2vw, 1rem);
            font-style: italic;
            padding: clamp(0.8rem, 2vw, 1rem) clamp(1rem, 3vw, 2rem);
            background: linear-gradient(90deg, transparent, rgba(255, 183, 77, 0.2), transparent);
            border-radius: 50px;
            border: 1px solid rgba(255, 183, 77, 0.3);
            backdrop-filter: blur(5px);
            animation: glowBorder 3s ease-in-out infinite;
        }

        @keyframes glowBorder {
            0%, 100% { border-color: rgba(255, 183, 77, 0.3); }
            50% { border-color: rgba(255, 183, 77, 0.8); }
        }

        .bottom-quote i {
            color: var(--accent);
            margin: 0 0.5rem;
            font-size: clamp(0.9rem, 2.2vw, 1.1rem);
            animation: bounce 2s ease infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }

        /* Floating farm elements */
        .floating-element {
            position: fixed;
            font-size: clamp(1.5rem, 4vw, 2rem);
            opacity: 0.15;
            pointer-events: none;
            z-index: -1;
            animation: floatAround 20s linear infinite;
        }

        .floating-1 { top: 20%; left: 10%; animation-delay: 0s; }
        .floating-2 { top: 70%; right: 15%; animation-delay: 5s; }
        .floating-3 { bottom: 20%; left: 20%; animation-delay: 10s; }
        .floating-4 { top: 40%; right: 25%; animation-delay: 15s; }

        @keyframes floatAround {
            0% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(20px, -20px) rotate(10deg); }
            50% { transform: translate(40px, 0) rotate(20deg); }
            75% { transform: translate(20px, 20px) rotate(10deg); }
            100% { transform: translate(0, 0) rotate(0deg); }
        }

        /* Responsive Design Overrides */
        @media (max-width: 1024px) {
            .content-wrapper {
                flex-direction: column;
            }

            .left-content {
                text-align: center;
            }

            .left-content p {
                margin: 0 auto 2rem;
            }

            .feature-list {
                align-items: center;
            }

            .left-content h1 {
                font-size: clamp(2rem, 5vw, 2.8rem);
            }

            .left-content::before,
            .left-content::after {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .location-container {
                flex-direction: column;
                gap: 0.8rem;
                text-align: center;
            }

            .live-updates {
                justify-content: center;
                gap: 1rem;
            }

            .glass-container {
                padding: 1.5rem;
            }

            .form-container {
                padding: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .left-content h1 {
                font-size: clamp(1.8rem, 6vw, 2.2rem);
            }
        }

        @media (max-width: 360px) {
            .location {
                flex-direction: column;
                gap: 0.3rem;
            }

            .live-updates {
                flex-direction: column;
                gap: 0.5rem;
            }

            .datetime {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<!-- Include Navbar -->
<jsp:include page="navbar.jsp"/>

<!-- Toast Notification Container -->
<div class="toast-container" id="toastContainer"></div>

<!-- Floating decorative elements -->
<div class="floating-element floating-1">🌽</div>
<div class="floating-element floating-2">🌻</div>
<div class="floating-element floating-3">🍎</div>
<div class="floating-element floating-4">🥕</div>

<!-- Location Bar -->
<div class="location-bar">
    <div class="location-container">
        <div class="location">
            <i class='bx bx-map'></i>
            <span>Kohlapur, Maharashtra</span>
            <span class="loading">Loading...</span>
        </div>
        <div class="live-updates">
            <span class="live-badge">LIVE</span>
            <div class="datetime">
                <i class='bx bx-calendar'></i>
                <span id="currentDateTime">Monday, 23 February 2026 at 09:46 pm</span>
            </div>
            <span class="live-text">
                    <i class='bx bx-rss'></i>
                    Live Updates
                </span>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="main-container">
    <div class="glass-container">
        <div class="content-wrapper">
            <!-- Left Content -->
            <div class="left-content">
                <h1>Redefining The Boundaries of Agriculture</h1>

                <div class="feature-list">
                    <div class="feature-item">
                        <i class='bx bx-cloud'></i>
                        <span>Real-time weather data</span>
                    </div>
                    <div class="feature-item">
                        <i class='bx bx-line-chart'></i>
                        <span>Live crop prices</span>
                    </div>
                    <div class="feature-item">
                        <i class='bx bx-bulb'></i>
                        <span>Smarter farming decisions</span>
                    </div>
                </div>

                <p>Join thousands of farmers already using AgroInsights to optimize their farming operations.</p>
            </div>

            <!-- Form Container -->
            <div class="form-container">
                <div class="form-tabs">
                    <button class="tab-btn active" onclick="switchTab('login')">Login</button>
                    <button class="tab-btn" onclick="switchTab('register')">Register</button>
                </div>

                <!-- Login Form -->
                <div id="loginForm" class="form-panel active">
                    <h2>Welcome Back!</h2>
                    <p class="form-subtitle">Continue your farming journey with real-time insights</p>

                    <form id="loginFormElement">
                        <div class="input-box">
                            <input type="text" name="username" id="loginUsername" placeholder="Username" required>
                            <i class='bx bxs-user'></i>
                        </div>

                        <div class="input-box">
                            <input type="password" name="password" id="loginPassword" placeholder="Password" required>
                            <i class='bx bxs-lock-alt'></i>
                        </div>

                        <div class="forgot-link">
                            <a href="#" onclick="showToast('Password reset link will be sent to your registered email!', 'info'); return false;">Forgot Password?</a>
                        </div>

                        <button type="submit" id="loginBtn" class="submit-btn">
                            <i class='bx bx-log-in'></i>
                            Login
                        </button>

                        <div class="divider">
                            <span>or continue with</span>
                        </div>

                        <div class="social-icons">
                            <a href="#" onclick="showToast('Google login feature coming soon!', 'info'); return false;"><i class='bx bxl-google'></i></a>
                            <a href="#" onclick="showToast('Facebook login feature coming soon!', 'info'); return false;"><i class='bx bxl-facebook'></i></a>
                            <a href="#" onclick="showToast('LinkedIn login feature coming soon!', 'info'); return false;"><i class='bx bxl-linkedin'></i></a>
                        </div>
                    </form>
                </div>

                <!-- Register Form -->
                <div id="registerForm" class="form-panel">
                    <h2>Create Account</h2>
                    <p class="form-subtitle">Join our community and start making smarter farming decisions</p>

                    <form id="registerFormElement">
                        <div class="input-box">
                            <input type="text" name="username" id="registerUsername" placeholder="Username" required>
                            <i class='bx bxs-user'></i>
                        </div>

                        <div class="input-box">
                            <input type="email" name="email" id="registerEmail" placeholder="Email" required>
                            <i class='bx bxs-envelope'></i>
                        </div>

                        <div class="input-box">
                            <input type="password" name="user_password" id="registerPassword" placeholder="Password" required>
                            <i class='bx bxs-lock-alt'></i>
                        </div>

                        <button type="submit" id="registerBtn" class="submit-btn">
                            <i class='bx bx-user-plus'></i>
                            Register
                        </button>

                        <div class="divider">
                            <span>or register with</span>
                        </div>

                        <div class="social-icons">
                            <a href="#" onclick="showToast('Google registration coming soon!', 'info'); return false;"><i class='bx bxl-google'></i></a>
                            <a href="#" onclick="showToast('Facebook registration coming soon!', 'info'); return false;"><i class='bx bxl-facebook'></i></a>
                            <a href="#" onclick="showToast('LinkedIn registration coming soon!', 'info'); return false;"><i class='bx bxl-linkedin'></i></a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bottom Quote -->
        <div class="bottom-quote">
            <i class='bx bx-quote-left'></i>
            Real-time weather data and live crop prices for smarter farming decisions.
            <i class='bx bx-quote-right'></i>
        </div>
    </div>
</div>

<script>
    // Toast Notification System
    function showToast(message, type = 'error', duration = 3000) {
        const container = document.getElementById('toastContainer');

        // Create toast element
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        // Set icon based on type
        let icon = 'bx-error-circle';
        let title = 'Error';

        switch(type) {
            case 'success':
                icon = 'bx-check-circle';
                title = 'Success';
                break;
            case 'warning':
                icon = 'bx-error';
                title = 'Warning';
                break;
            case 'info':
                icon = 'bx-info-circle';
                title = 'Information';
                break;
            default:
                icon = 'bx-error-circle';
                title = 'Error';
        }

        // Toast HTML structure
        toast.innerHTML = `
            <div class="toast-icon">
                <i class='bx ${icon}'></i>
            </div>
            <div class="toast-content">
                <div class="toast-title">${title}</div>
                <div class="toast-message">${message}</div>
            </div>
            <button class="toast-close" onclick="this.parentElement.remove()">
                <i class='bx bx-x'></i>
            </button>
            <div class="toast-progress"></div>
        `;

        // Add to container
        container.appendChild(toast);

        // Trigger animation
        setTimeout(() => {
            toast.classList.add('show');
        }, 10);

        // Auto remove after duration
        const progressBar = toast.querySelector('.toast-progress');
        progressBar.style.transition = `transform ${duration/1000}s linear`;

        setTimeout(() => {
            progressBar.style.transform = 'scaleX(0)';
        }, 50);

        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 400);
        }, duration);

        // Close button functionality
        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.addEventListener('click', () => {
            toast.classList.remove('show');
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.remove();
                }
            }, 400);
        });
    }

    // Remove error styling from all inputs
    function removeErrorStyles() {
        document.querySelectorAll('.input-box input').forEach(input => {
            input.classList.remove('error');
        });
    }

    // Handle Login Form with AJAX
    document.getElementById('loginFormElement').addEventListener('submit', async function(e) {
        e.preventDefault();

        const username = document.getElementById('loginUsername').value;
        const password = document.getElementById('loginPassword').value;
        const loginBtn = document.getElementById('loginBtn');

        // Remove previous error styles
        removeErrorStyles();

        // Client-side validation
        if (!username || !password) {
            showToast('Please fill in all fields', 'warning');
            return;
        }

        if (password.length < 6) {
            document.getElementById('loginPassword').classList.add('error');
            showToast('Password must be at least 6 characters long', 'error');
            return;
        }

        // Disable button and show loading
        loginBtn.disabled = true;
        loginBtn.innerHTML = '<i class="bx bx-loader-alt bx-spin"></i> Logging in...';

        try {
            const formData = new URLSearchParams();
            formData.append('username', username);
            formData.append('password', password);

            const response = await fetch('login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showToast('Login successful! Redirecting...', 'success');
                setTimeout(() => {
                    window.location.href = data.redirect;
                }, 1500);
            } else {
                showToast(data.message, 'error');
                if (data.error === 'invalid') {
                    document.getElementById('loginUsername').classList.add('error');
                    document.getElementById('loginPassword').classList.add('error');
                }
            }
        } catch (error) {
            showToast('Connection error. Please try again.', 'error');
        } finally {
            // Reset button
            loginBtn.disabled = false;
            loginBtn.innerHTML = '<i class="bx bx-log-in"></i> Login';
        }
    });

    // Handle Register Form with AJAX
    document.getElementById('registerFormElement').addEventListener('submit', async function(e) {
        e.preventDefault();

        const username = document.getElementById('registerUsername').value;
        const email = document.getElementById('registerEmail').value;
        const password = document.getElementById('registerPassword').value;
        const registerBtn = document.getElementById('registerBtn');

        // Remove previous error styles
        removeErrorStyles();

        // Validation
        if (!username || !email || !password) {
            showToast('Please fill in all fields', 'warning');
            return;
        }

        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            document.getElementById('registerEmail').classList.add('error');
            showToast('Please enter a valid email address', 'error');
            return;
        }

        // Password validation
        if (password.length < 6) {
            document.getElementById('registerPassword').classList.add('error');
            showToast('Password must be at least 6 characters long', 'error');
            return;
        }

        // Username validation
        if (username.length < 3) {
            document.getElementById('registerUsername').classList.add('error');
            showToast('Username must be at least 3 characters long', 'warning');
            return;
        }

        // Disable button and show loading
        registerBtn.disabled = true;
        registerBtn.innerHTML = '<i class="bx bx-loader-alt bx-spin"></i> Creating account...';

        try {
            const formData = new URLSearchParams();
            formData.append('username', username);
            formData.append('email', email);
            formData.append('user_password', password);

            const response = await fetch('Register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showToast(data.message, 'success');
                // Clear form
                document.getElementById('registerFormElement').reset();
                // Switch to login tab after 2 seconds
                setTimeout(() => {
                    switchTab('login');
                }, 2000);
            } else {
                showToast(data.message, 'error');
                // Highlight the problematic field
                if (data.field === 'username' || data.field === 'both') {
                    document.getElementById('registerUsername').classList.add('error');
                }
                if (data.field === 'email' || data.field === 'both') {
                    document.getElementById('registerEmail').classList.add('error');
                }
            }
        } catch (error) {
            showToast('Connection error. Please try again.', 'error');
        } finally {
            // Reset button
            registerBtn.disabled = false;
            registerBtn.innerHTML = '<i class="bx bx-user-plus"></i> Register';
        }
    });

    function switchTab(tab) {
        const loginForm = document.getElementById('loginForm');
        const registerForm = document.getElementById('registerForm');
        const tabs = document.querySelectorAll('.tab-btn');

        if (tab === 'login') {
            loginForm.classList.add('active');
            registerForm.classList.remove('active');
            tabs[0].classList.add('active');
            tabs[1].classList.remove('active');
        } else {
            registerForm.classList.add('active');
            loginForm.classList.remove('active');
            tabs[1].classList.add('active');
            tabs[0].classList.remove('active');
        }

        // Remove error styles when switching tabs
        removeErrorStyles();
    }

    // Add floating animation to inputs
    const inputs = document.querySelectorAll('.input-box input');
    inputs.forEach(input => {
        input.addEventListener('focus', () => {
            input.parentElement.style.transform = 'scale(1.02)';
        });

        input.addEventListener('blur', () => {
            input.parentElement.style.transform = 'scale(1)';
        });
    });

    // Update datetime
    function updateDateTime() {
        const now = new Date();
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        };
        const dateTimeStr = now.toLocaleString('en-US', options);
        const datetimeSpan = document.getElementById('currentDateTime');
        if (datetimeSpan) {
            datetimeSpan.textContent = dateTimeStr;
        }
    }

    // Initialize
    updateDateTime();
    setInterval(updateDateTime, 60000);
</script>

<!-- Add Gson library dependency info (for reference) -->
<!-- Make sure to add gson-2.10.1.jar to WEB-INF/lib -->

</body>
</html>