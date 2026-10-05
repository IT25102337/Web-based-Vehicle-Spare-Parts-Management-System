<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Spare Parts Management System | PartTrack</title>

    <!-- Theme Initialization BEFORE Render to prevent flash -->
    <script>
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', s);
        })();
    </script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --brand-orange: #eb6014;
            --brand-orange-hover: #d44d05;
            --brand-dark: #22262a;
            --brand-grey: #4a5568;
            --input-bg: #eff2f5;
            --input-border: #e2e8f0;
            --bg-page: #f8f9fa;
            --card-bg: #ffffff;
            --card-border: rgba(0, 0, 0, 0.04);
            --card-shadow: 0 18px 45px -8px rgba(15, 23, 42, 0.16), 0 0 1px 1px rgba(0, 0, 0, 0.04);
            --txt-heading: #22262a;
            --txt-body: #1e293b;
            --txt-muted: #64748b;
            --txt-footer: #94a3b8;
            --header-sub: #1e3a8a;
            --header-sub-text: #64748b;
            --divider-col: #cbd5e1;
        }

        [data-theme='dark'] {
            --brand-orange: #f97316;
            --brand-orange-hover: #ea580c;
            --brand-dark: #f8fafc;
            --brand-grey: #94a3b8;
            --input-bg: #0b1120;
            --input-border: #334155;
            --bg-page: #060912;
            --card-bg: #111827;
            --card-border: rgba(255, 255, 255, 0.08);
            --card-shadow: 0 25px 60px -10px rgba(0, 0, 0, 0.8), 0 0 1px 1px rgba(255, 255, 255, 0.06);
            --txt-heading: #f8fafc;
            --txt-body: #f1f5f9;
            --txt-muted: #94a3b8;
            --txt-footer: #64748b;
            --header-sub: #60a5fa;
            --header-sub-text: #94a3b8;
            --divider-col: #334155;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-page);
            background-image: radial-gradient(circle at 10% 20%, rgba(240, 243, 246, 0.8) 0%, rgba(248, 249, 250, 1) 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow-x: hidden;
            color: var(--txt-body);
            transition: background-color 0.25s ease, color 0.25s ease;
        }

        [data-theme='dark'] body {
            background-image: radial-gradient(circle at 10% 20%, rgba(17, 24, 39, 0.85) 0%, rgba(6, 9, 18, 1) 100%);
        }

        /* ── FLOATING THEME TOGGLE BUTTON IN BOTTOM-LEFT ── */
        .theme-toggle-floating {
            position: fixed;
            bottom: 2rem;
            left: 2.25rem;
            right: auto;
            z-index: 1000;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border: 1px solid var(--divider-col);
            border-radius: 99px;
            padding: 0.5rem 1.05rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.84rem;
            font-weight: 700;
            color: var(--txt-body);
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
            transition: all 0.2s ease;
        }

        [data-theme='dark'] .theme-toggle-floating {
            background: rgba(17, 24, 39, 0.85);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
            border-color: rgba(255, 255, 255, 0.12);
            color: #f1f5f9;
        }

        .theme-toggle-floating:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            border-color: var(--brand-orange);
        }

        /* ── TOP-LEFT CORPORATE PARTNER HEADER ── */
        .page-header {
            padding: 2.2rem 3.5rem 1rem 3.5rem;
            position: relative;
            z-index: 20;
        }

        .partner-branding-wrap {
            display: inline-flex;
            align-items: center;
            gap: 1.8rem;
        }

        .brand-logo-group {
            display: flex;
            flex-direction: column;
            line-height: 1.05;
        }

        .brand-logo-group .logo-top {
            font-size: 1.55rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: var(--brand-orange);
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .brand-logo-group .logo-sub {
            font-size: 1.35rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: var(--brand-dark);
            transition: color 0.25s ease;
        }

        .brand-separator {
            width: 1.5px;
            height: 44px;
            background-color: var(--divider-col);
            transition: background-color 0.25s ease;
        }

        .associate-group {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }

        .associate-group .mrc-title {
            font-size: 1.18rem;
            font-weight: 800;
            color: var(--header-sub);
            display: flex;
            align-items: center;
            gap: 0.4rem;
            letter-spacing: -0.01em;
            transition: color 0.25s ease;
        }

        .associate-group .mrc-sub {
            font-size: 0.74rem;
            color: var(--header-sub-text);
            font-weight: 600;
            letter-spacing: 0.02em;
            transition: color 0.25s ease;
        }

        /* ── BACKGROUND OVERHEAD CAR ON RIGHT ── */
        .bg-car-overhead-container {
            position: fixed;
            top: 0;
            bottom: 0;
            right: -60px;
            width: 320px;
            height: 100vh;
            pointer-events: none;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            opacity: 0.95;
            transition: all 0.3s ease;
        }

        .bg-car-overhead-container img {
            height: 100vh;
            max-width: none;
            object-fit: contain;
            object-position: right center;
            filter: drop-shadow(-10px 0 25px rgba(0, 0, 0, 0.08));
        }

        [data-theme='light'] .car-topdown-light { display: block; }
        [data-theme='light'] .car-topdown-dark { display: none; }
        [data-theme='dark'] .car-topdown-light { display: none; }
        [data-theme='dark'] .car-topdown-dark { display: block; filter: drop-shadow(-15px 0 35px rgba(0, 0, 0, 0.8)); }

        /* ── MAIN CONTENT WRAPPER ── */
        .main-auth-stage {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem 2rem;
            position: relative;
            z-index: 15;
        }

        /* ── FLOATING CENTRAL LOGIN CARD ── */
        .login-card-modal {
            background-color: var(--card-bg);
            border-radius: 4px;
            border: 1px solid var(--card-border);
            box-shadow: var(--card-shadow);
            max-width: 900px;
            width: 100%;
            min-height: 440px;
            display: flex;
            overflow: hidden;
            position: relative;
            transition: background-color 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
        }

        /* Left Half: Car Image Column */
        .login-card-left {
            flex: 1.05;
            position: relative;
            background-color: #0b0f19;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card-left img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center left;
            display: block;
        }

        [data-theme='light'] .car-img-light { display: block; }
        [data-theme='light'] .car-img-dark { display: none; }
        [data-theme='dark'] .car-img-light { display: none; }
        [data-theme='dark'] .car-img-dark { display: block; }

        /* Right Half: Form Column */
        .login-card-right {
            flex: 1.25;
            padding: 3rem 2.8rem 2.5rem 2.8rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background-color: var(--card-bg);
            transition: background-color 0.25s ease;
        }

        /* ── BIG BOLD HEADINGS ── */
        .card-heading-title {
            font-size: 2.15rem;
            font-weight: 700;
            line-height: 1.15;
            letter-spacing: -0.03em;
            color: var(--txt-heading);
            margin-bottom: 0.15rem;
            transition: color 0.25s ease;
        }

        .card-heading-subtitle {
            font-size: 2.15rem;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: -0.03em;
            color: var(--brand-orange);
            margin-bottom: 1.65rem;
        }

        /* ── RECTANGULAR INPUTS ── */
        .flat-input-field {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 3px;
            padding: 0.65rem 0.95rem;
            font-size: 0.92rem;
            color: var(--txt-body);
            width: 100%;
            transition: all 0.2s ease;
            outline: none;
            font-family: inherit;
        }

        .flat-input-field:focus {
            background-color: var(--input-bg);
            border-color: var(--brand-orange);
            box-shadow: 0 0 0 2px rgba(235, 96, 20, 0.22);
        }

        .flat-input-field::placeholder {
            color: var(--txt-muted);
            font-weight: 500;
        }

        /* ── REMEMBER ME & FORGOT PASSWORD ROW ── */
        .auth-meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 0.85rem;
            margin-bottom: 1.5rem;
            font-size: 0.84rem;
        }

        .custom-checkbox-label {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            color: var(--txt-muted);
            cursor: pointer;
            user-select: none;
            font-weight: 500;
        }

        .custom-checkbox-label input[type="checkbox"] {
            accent-color: var(--brand-orange);
            width: 15px;
            height: 15px;
            border-radius: 2px;
            cursor: pointer;
        }

        .link-forgot {
            color: var(--txt-muted);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.15s ease;
        }

        .link-forgot:hover {
            color: var(--brand-orange);
            text-decoration: underline;
        }

        /* ── VIBRANT ORANGE LOGIN BUTTON ── */
        .btn-brand-orange {
            background-color: var(--brand-orange);
            color: #ffffff;
            font-weight: 600;
            font-size: 0.92rem;
            border: none;
            border-radius: 3px;
            padding: 0.62rem 2.2rem;
            cursor: pointer;
            transition: all 0.18s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.45rem;
            box-shadow: 0 4px 12px rgba(235, 96, 20, 0.3);
        }

        .btn-brand-orange:hover {
            background-color: var(--brand-orange-hover);
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(235, 96, 20, 0.42);
        }

        .btn-brand-orange:active {
            transform: translateY(0);
        }

        .role-selector-wrap {
            margin-bottom: 0.85rem;
        }

        /* ── PAGE FOOTER ── */
        .page-footer {
            padding: 1.25rem 2rem;
            text-align: center;
            font-size: 0.76rem;
            color: var(--txt-footer);
            font-weight: 500;
            position: relative;
            z-index: 20;
            transition: color 0.25s ease;
        }

        /* Password eye button */
        .password-field-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .password-eye-btn {
            position: absolute;
            right: 10px;
            background: none;
            border: none;
            color: var(--txt-muted);
            cursor: pointer;
            padding: 4px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .password-eye-btn:hover {
            color: var(--txt-body);
        }

        /* ── RESPONSIVE ADAPTATIONS ── */
        @media (max-width: 900px) {
            .bg-car-overhead-container {
                display: none;
            }
            .theme-toggle-floating {
                bottom: 1.25rem;
                left: 1.25rem;
                right: auto;
                top: auto;
            }
            .page-header {
                padding: 1.5rem 1.5rem 0.5rem 1.5rem;
            }
            .login-card-modal {
                flex-direction: column;
                max-width: 480px;
            }
            .login-card-left {
                height: 190px;
                flex: none;
            }
            .login-card-right {
                padding: 2rem 1.8rem;
            }
            .card-heading-title, .card-heading-subtitle {
                font-size: 1.7rem;
            }
        }

        @media (max-width: 768px) {
            .page-footer {
                padding-bottom: 4.5rem;
            }
        }
    </style>
</head>
<body>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  FLOATING THEME TOGGLE BUTTON (BOTTOM LEFT)       -->
    <!-- ═════════════════════════════════════════════════ -->
    <button class="theme-toggle-floating" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
        <i id="themeToggleIcon" class="bi bi-moon-stars-fill"></i>
        <span id="themeToggleLabel">Theme</span>
    </button>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  1. TOP-LEFT BRANDING HEADER                      -->
    <!-- ═════════════════════════════════════════════════ -->
    <header class="page-header">
        <div class="partner-branding-wrap">
            <!-- Brand 1: PartTrack Automotive -->
            <div class="brand-logo-group">
                <div class="logo-top">
                    <i class="bi bi-gear-wide-connected text-warning"></i> PartTrack
                </div>
                <div class="logo-sub">Automotive</div>
            </div>

            <!-- Divider Line -->
            <div class="brand-separator"></div>

            <!-- Brand 2: Associate Partner Network -->
            <div class="associate-group">
                <div class="mrc-title">
                    <i class="bi bi-shield-check"></i> Global Auto Network
                </div>
                <div class="mrc-sub">Global Associate Partner</div>
            </div>
        </div>
    </header>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  2. TOP-DOWN OVERHEAD CAR ON RIGHT (BACKGROUND)   -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="bg-car-overhead-container" aria-hidden="true">
        <img src="/images/car_top_down.jpg" alt="Overhead luxury vehicle" class="car-topdown-light">
        <img src="/images/car_top_down_dark.jpg" alt="Overhead luxury vehicle dark" class="car-topdown-dark">
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  3. MAIN CONTENT: CENTRAL FLOATING LOGIN CARD     -->
    <!-- ═════════════════════════════════════════════════ -->
    <main class="main-auth-stage">
        <div class="login-card-modal">

            <!-- Left: Front 3/4 Car Photo (Light / Dark Adaptive) -->
            <div class="login-card-left">
                <img src="/images/login_card_car.jpg" alt="Vehicle Front Profile" class="car-img-light">
                <img src="/images/login_card_car_dark.jpg" alt="Vehicle Front Profile Dark" class="car-img-dark">
            </div>

            <!-- Right: Login & Registration Portal -->
            <div class="login-card-right">

                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show py-2 px-3 small rounded-1 mb-3 border d-flex align-items-center gap-2" role="alert">
                        <i class="bi bi-check-circle-fill text-success"></i>
                        <div>${successMessage}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage || not empty sessionScope.sessionErrorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show py-2 px-3 small rounded-1 mb-3 border d-flex align-items-center gap-2" role="alert">
                        <i class="bi bi-exclamation-circle-fill text-danger"></i>
                        <div>${not empty errorMessage ? errorMessage : sessionScope.sessionErrorMessage}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="sessionErrorMessage" scope="session"/>
                </c:if>

                <!-- ═════════════════════════════════════════════ -->
                <!--  VIEW 1: SIGN IN                              -->
                <!-- ═════════════════════════════════════════════ -->
                <div id="signInSection" style="${activeTab == 'signup' ? 'display:none;' : 'display:block;'}">

                    <!-- Title matching reference design -->
                    <h1 class="card-heading-title">Vehicle Spare Parts</h1>
                    <h2 class="card-heading-subtitle">Management System</h2>

                    <form action="/login" method="post" id="loginForm" autocomplete="off">
                        <!-- Username Field -->
                        <div class="mb-2">
                            <input type="text" name="username" id="loginUsername" class="flat-input-field"
                                   placeholder="Username" required autofocus autocomplete="off" value="">
                        </div>

                        <!-- Password Field -->
                        <div class="mb-1 password-field-group">
                            <input type="password" name="password" id="loginPassword" class="flat-input-field pe-5"
                                   placeholder="Password" required autocomplete="new-password" value="">
                            <button class="password-eye-btn" type="button" onclick="togglePassVisibility('loginPassword', 'eyeIconLogin')" tabindex="-1">
                                <i class="bi bi-eye" id="eyeIconLogin"></i>
                            </button>
                        </div>

                        <!-- Remember Me & Forgot Password -->
                        <div class="auth-meta-row">
                            <label class="custom-checkbox-label">
                                <input type="checkbox" name="rememberMe" id="rememberMe">
                                <span>Remember Me</span>
                            </label>
                            <a href="javascript:void(0)" onclick="alert('For password resets, please contact the System Administrator at admin@parttrack.com')" class="link-forgot">
                                Forgot Password?
                            </a>
                        </div>

                        <!-- Action Button Row -->
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <button type="submit" class="btn-brand-orange" id="loginSubmitBtn">
                                Login
                            </button>
                            <a href="javascript:void(0)" onclick="switchAuthTab('signup')" class="small text-decoration-none" style="color:var(--txt-muted);">
                                Need an account? <span class="fw-bold" style="color:var(--brand-orange)">Register</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- ═════════════════════════════════════════════ -->
                <!--  VIEW 2: CREATE CUSTOMER ACCOUNT (SIGN UP)    -->
                <!-- ═════════════════════════════════════════════ -->
                <div id="signUpSection" style="${activeTab == 'signup' ? 'display:block;' : 'display:none;'}">

                    <h1 class="card-heading-title" style="font-size:1.85rem;">Create Account</h1>
                    <h2 class="card-heading-subtitle" style="font-size:1.85rem; margin-bottom:1.15rem;">Customer Portal</h2>

                    <form action="/signup" method="post" id="signupForm" autocomplete="off" onsubmit="return validateSignUpForm()">
                        <!-- Full Name -->
                        <div class="mb-2">
                            <input type="text" name="fullName" id="signupFullName" class="flat-input-field"
                                   placeholder="Full Name (e.g. Kasun Perera)" autocomplete="off" required>
                        </div>

                        <!-- Email -->
                        <div class="mb-2">
                            <input type="email" name="email" id="signupEmail" class="flat-input-field"
                                   placeholder="Email Address (e.g. kasun@example.com)" autocomplete="off" required>
                        </div>

                        <!-- Username -->
                        <div class="mb-2">
                            <input type="text" name="username" id="signupUsername" class="flat-input-field"
                                   placeholder="Desired Username" minlength="3" autocomplete="off" required>
                        </div>

                        <!-- Password -->
                        <div class="mb-2 password-field-group">
                            <input type="password" name="password" id="signupPassword" class="flat-input-field pe-5"
                                   placeholder="Password (Min. 4 characters)" minlength="4" autocomplete="new-password" required>
                            <button class="password-eye-btn" type="button" onclick="togglePassVisibility('signupPassword', 'eyeIconSignup')" tabindex="-1">
                                <i class="bi bi-eye" id="eyeIconSignup"></i>
                            </button>
                        </div>

                        <!-- Confirm Password -->
                        <div class="mb-2">
                            <input type="password" name="confirmPassword" id="signupConfirmPassword" class="flat-input-field"
                                   placeholder="Confirm Password" autocomplete="new-password" required>
                            <span id="signupPassError" class="text-danger small fw-bold mt-1" style="display:none;"></span>
                        </div>

                        <div class="d-flex align-items-center justify-content-between mt-3 flex-wrap gap-2">
                            <button type="submit" class="btn-brand-orange">
                                Register Account
                            </button>
                            <a href="javascript:void(0)" onclick="switchAuthTab('signin')" class="small text-decoration-none" style="color:var(--txt-muted);">
                                Already registered? <span class="fw-bold" style="color:var(--brand-orange)">Sign In &rarr;</span>
                            </a>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </main>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  4. SUBTLE FOOTER                                 -->
    <!-- ═════════════════════════════════════════════════ -->
    <footer class="page-footer">
        &copy; PartTrack &amp; Global Automotive Network 2026. All rights reserved.
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // ============================================
        //  THEME TOGGLE LOGIC
        // ============================================
        function toggleTheme() {
            var h = document.documentElement;
            var isDark = h.getAttribute('data-theme') === 'dark';
            var next = isDark ? 'light' : 'dark';
            h.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            updateToggleUI(next);
        }

        function updateToggleUI(theme) {
            var icon = document.getElementById('themeToggleIcon');
            var label = document.getElementById('themeToggleLabel');
            if (icon) {
                icon.className = (theme === 'dark') ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
            }
            if (label) {
                label.textContent = (theme === 'dark') ? 'Light Mode' : 'Dark Mode';
            }
        }

        // Initialize toggle button state on DOM load
        document.addEventListener('DOMContentLoaded', function() {
            var cur = localStorage.getItem('theme') || 'light';
            updateToggleUI(cur);
        });

        function switchAuthTab(tab) {
            var signInSec = document.getElementById('signInSection');
            var signUpSec = document.getElementById('signUpSection');

            if (tab === 'signup') {
                signInSec.style.display = 'none';
                signUpSec.style.display = 'block';
            } else {
                signUpSec.style.display = 'none';
                signInSec.style.display = 'block';
            }
        }

        function togglePassVisibility(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon  = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        function validateSignUpForm() {
            var pass = document.getElementById('signupPassword').value;
            var conf = document.getElementById('signupConfirmPassword').value;
            var err  = document.getElementById('signupPassError');

            if (pass !== conf) {
                err.textContent = 'Passwords do not match. Please re-enter.';
                err.style.display = 'block';
                return false;
            }
            if (pass.length < 4) {
                err.textContent = 'Password must be at least 4 characters.';
                err.style.display = 'block';
                return false;
            }
            err.style.display = 'none';
            return true;
        }
    </script>
</body>
</html>
