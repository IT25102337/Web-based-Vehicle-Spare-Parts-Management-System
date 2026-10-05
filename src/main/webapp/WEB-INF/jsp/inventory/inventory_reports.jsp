<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Audit &amp; Reports | AutoParts Depot</title>

    <script>
        (function(){
            var t = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', t);
        })();
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --bg: #f8fafc;
            --card: #ffffff;
            --card-subtle: #f4f4f5;
            --border: #e4e4e7;
            --border-hover: #d4d4d8;
            --txt: #09090b;
            --txt2: #52525b;
            --txt-muted: #71717a;
            --brand-red: #cc1d24;
            --brand-red-hover: #b0151b;
            --brand-dark: #09090b;
            --pill-bg: #f4f4f5;
            --sidebar-bg: #ffffff;
            --table-head: #fafafa;
            --table-hover: #f8fafc;
            --radius-lg: 20px;
            --radius-md: 14px;
            --radius-sm: 8px;
            --shadow-subtle: 0 1px 3px rgba(0,0,0,0.04), 0 8px 24px -4px rgba(0,0,0,0.04);
            --shadow-modal: 0 20px 40px -10px rgba(0,0,0,0.18);
        }

        [data-theme="dark"] {
            --bg: #09090b;
            --card: #141416;
            --card-subtle: #1c1c1f;
            --border: #27272a;
            --border-hover: #3f3f46;
            --txt: #f4f4f5;
            --txt2: #a1a1aa;
            --txt-muted: #71717a;
            --brand-red: #e11d48;
            --brand-red-hover: #f43f5e;
            --brand-dark: #ffffff;
            --pill-bg: #1f1f23;
            --sidebar-bg: #141416;
            --table-head: #18181b;
            --table-hover: #1b1b1f;
            --shadow-subtle: 0 1px 3px rgba(0,0,0,0.4), 0 8px 24px -4px rgba(0,0,0,0.35);
            --shadow-modal: 0 20px 40px -10px rgba(0,0,0,0.7);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg);
            color: var(--txt);
            min-height: 100vh;
            margin: 0;
            display: flex;
            transition: background-color 0.2s ease, color 0.2s ease;
            -webkit-font-smoothing: antialiased;
        }

        /* SIDEBAR RAIL */
        .sidebar-rail {
            width: 76px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.5rem 0;
            z-index: 1030;
            transition: background 0.2s, border-color 0.2s;
        }

        .brand-logo-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: var(--brand-dark);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 2rem;
            text-decoration: none;
            transition: transform 0.2s;
        }
        [data-theme="dark"] .brand-logo-icon {
            background: #ffffff;
            color: #09090b;
        }
        .brand-logo-icon:hover { transform: scale(1.05); }

        .sidebar-nav {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            width: 100%;
            align-items: center;
        }

        .sidebar-icon-link {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--txt2);
            font-size: 1.2rem;
            text-decoration: none;
            transition: all 0.2s ease;
            position: relative;
        }
        .sidebar-icon-link:hover {
            background-color: var(--card-subtle);
            color: var(--txt);
        }
        .sidebar-icon-link.active {
            background-color: var(--brand-dark);
            color: #ffffff;
        }
        [data-theme="dark"] .sidebar-icon-link.active {
            background-color: #ffffff;
            color: #09090b;
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            background-color: var(--brand-red);
            border: 2px solid var(--sidebar-bg);
            border-radius: 50%;
            position: absolute;
            top: 7px;
            right: 7px;
        }

        .sidebar-bottom {
            margin-top: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
        }

        .theme-toggle-sidebar, .logout-icon-link {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--txt2);
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .theme-toggle-sidebar:hover, .logout-icon-link:hover {
            color: var(--txt);
            border-color: var(--border-hover);
            background: var(--card-subtle);
        }

        /* MAIN CONTENT */
        .main-content {
            margin-left: 76px;
            padding: 2.25rem 3rem;
            width: calc(100% - 76px);
            min-height: 100vh;
            max-width: 1600px;
        }

        /* TOPBAR */
        .topbar-clean {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .topbar-title {
            font-size: 1.35rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            text-transform: uppercase;
            margin: 0;
            color: var(--txt);
        }
        .topbar-sub {
            font-size: 0.82rem;
            color: var(--txt-muted);
            margin: 0;
            font-weight: 500;
        }

        /* BUTTONS */
        .btn-pill-dark {
            background: var(--brand-dark);
            color: #ffffff !important;
            border: 1px solid var(--brand-dark);
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        [data-theme="dark"] .btn-pill-dark {
            background: #ffffff;
            color: #09090b !important;
            border-color: #ffffff;
        }
        .btn-pill-dark:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .btn-pill-white {
            background: #ffffff;
            color: #09090b !important;
            border: 1px solid #ffffff;
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-white:hover {
            background: #f4f4f5;
            transform: translateY(-1px);
        }

        .btn-pill-outline {
            background: transparent;
            color: var(--txt) !important;
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-outline:hover {
            border-color: var(--txt);
            background: var(--card-subtle);
        }

        .btn-pill-ghost {
            background: rgba(255, 255, 255, 0.12);
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-ghost:hover {
            background: rgba(255, 255, 255, 0.22);
            transform: translateY(-1px);
        }

        .btn-pill-red {
            background: var(--brand-red);
            color: #ffffff !important;
            border: 1px solid var(--brand-red);
            border-radius: 9999px;
            padding: 0.45rem 1.15rem;
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-red:hover {
            background: var(--brand-red-hover);
            transform: translateY(-1px);
        }

        /* HERO BANNER */
        .hero-ev {
            position: relative;
            height: 380px;
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2.5rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 2.75rem 3rem;
            background: #09090b;
        }
        .hero-ev-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center 40%;
            opacity: 0.65;
            transition: transform 0.5s ease;
        }
        .hero-ev:hover .hero-ev-bg { transform: scale(1.02); }
        .hero-ev-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(9,9,11,0.15) 0%, rgba(9,9,11,0.5) 45%, rgba(9,9,11,0.92) 100%);
        }
        .hero-ev-content {
            position: relative;
            z-index: 2;
            color: #ffffff;
            max-width: 900px;
        }

        .hero-metrics-strip {
            display: flex;
            gap: 2rem;
            margin-bottom: 1.25rem;
            flex-wrap: wrap;
        }
        .hero-metric-item {
            display: flex;
            flex-direction: column;
        }
        .hero-metric-num {
            font-size: 1.35rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
            line-height: 1.1;
        }
        .hero-metric-lbl {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: rgba(255, 255, 255, 0.65);
            font-weight: 600;
        }

        .hero-ev-title {
            font-size: 2.4rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            text-transform: uppercase;
            line-height: 1.1;
            margin: 0 0 0.6rem 0;
            color: #ffffff;
        }
        .hero-ev-sub {
            font-size: 0.95rem;
            color: rgba(255, 255, 255, 0.82);
            margin: 0 0 1.5rem 0;
            max-width: 680px;
            font-weight: 400;
        }

        /* BENTO CARDS */
        .section-headline-box {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 1.5rem;
            gap: 1.5rem;
            flex-wrap: wrap;
        }
        .section-title-huge {
            font-size: 1.65rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            text-transform: uppercase;
            line-height: 1.1;
            margin: 0;
            color: var(--txt);
        }
        .section-sub-clean {
            font-size: 0.88rem;
            color: var(--txt-muted);
            margin: 0;
            max-width: 520px;
        }

        .bento-card-clean {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-subtle);
            transition: all 0.25s ease;
            margin-bottom: 2rem;
        }
        .bento-card-clean:hover {
            border-color: var(--border-hover);
        }

        .kpi-minimal-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-subtle);
            transition: all 0.2s ease;
        }
        .kpi-minimal-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }
        .kpi-metric-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
        }
        .kpi-tag {
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--txt-muted);
        }
        .kpi-icon-pill {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: var(--card-subtle);
            color: var(--txt);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
        }
        .kpi-val {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            line-height: 1.1;
            margin: 0 0 0.4rem 0;
            color: var(--txt);
        }
        .kpi-subnote {
            font-size: 0.8rem;
            color: var(--txt2);
            margin: 0;
        }

        /* TABLES */
        .table-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-subtle);
            margin-bottom: 2.5rem;
            overflow: hidden;
        }
        .table-card-header {
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            border-bottom: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .table-card-title {
            font-size: 1.1rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            text-transform: uppercase;
            margin: 0;
            color: var(--txt);
            display: flex;
            align-items: center;
            gap: 0.65rem;
        }
        .table-card-sub {
            font-size: 0.82rem;
            color: var(--txt-muted);
            margin: 0.2rem 0 0 0;
        }

        .table-minimal {
            width: 100%;
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }
        .table-minimal th {
            background: var(--table-head);
            color: var(--txt-muted);
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 0.9rem 1.5rem;
            border-bottom: 1px solid var(--border);
            border-top: none;
            white-space: nowrap;
        }
        .table-minimal td {
            padding: 1.1rem 1.5rem;
            color: var(--txt);
            font-size: 0.88rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            background: transparent;
            transition: background 0.15s;
        }
        .table-minimal tbody tr:last-child td {
            border-bottom: none;
        }
        .table-minimal tbody tr:hover td {
            background: var(--table-hover);
        }

        .sku-code {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            font-size: 0.82rem;
            color: var(--txt);
            letter-spacing: 0.02em;
        }

        .tag-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            background: var(--pill-bg);
            color: var(--txt);
            border: 1px solid var(--border);
        }

        .badge-status-approved {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .badge-status-pending {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.25);
        }

        .badge-status-reviewed {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(14, 165, 233, 0.1);
            color: #0ea5e9;
            border: 1px solid rgba(14, 165, 233, 0.25);
        }

        .btn-action-view, .btn-action-txt, .btn-action-pdf, .btn-action-delete {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
            text-decoration: none;
            font-size: 0.95rem;
            position: relative;
        }

        /* 1. View button (Indigo/Blue) */
        .btn-action-view {
            background: rgba(59, 130, 246, 0.1);
            color: #2563eb;
            border: 1px solid rgba(59, 130, 246, 0.22);
        }
        .btn-action-view:hover {
            background: #2563eb;
            color: #ffffff;
            border-color: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        /* 2. Download TXT button (Emerald/Green) */
        .btn-action-txt {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
            border: 1px solid rgba(16, 185, 129, 0.22);
        }
        .btn-action-txt:hover {
            background: #059669;
            color: #ffffff;
            border-color: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
        }

        /* 3. Download PDF button (Crimson/Red) */
        .btn-action-pdf {
            background: rgba(225, 29, 72, 0.1);
            color: #e11d48;
            border: 1px solid rgba(225, 29, 72, 0.22);
        }
        .btn-action-pdf:hover {
            background: #e11d48;
            color: #ffffff;
            border-color: #e11d48;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(225, 29, 72, 0.3);
        }

        /* 4. Delete button (Slate to Danger) */
        .btn-action-delete {
            background: rgba(100, 116, 139, 0.08);
            color: #64748b;
            border: 1px solid rgba(100, 116, 139, 0.2);
        }
        .btn-action-delete:hover {
            background: #dc2626;
            color: #ffffff;
            border-color: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
        }

        /* Dark mode overrides for high contrast and vibrant feel */
        [data-theme="dark"] .btn-action-view {
            background: rgba(59, 130, 246, 0.16);
            color: #60a5fa;
            border-color: rgba(59, 130, 246, 0.32);
        }
        [data-theme="dark"] .btn-action-view:hover {
            background: #3b82f6;
            color: #ffffff;
            border-color: #3b82f6;
        }

        [data-theme="dark"] .btn-action-txt {
            background: rgba(16, 185, 129, 0.16);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.32);
        }
        [data-theme="dark"] .btn-action-txt:hover {
            background: #10b981;
            color: #ffffff;
            border-color: #10b981;
        }

        [data-theme="dark"] .btn-action-pdf {
            background: rgba(225, 29, 72, 0.16);
            color: #fb7185;
            border-color: rgba(225, 29, 72, 0.32);
        }
        [data-theme="dark"] .btn-action-pdf:hover {
            background: #f43f5e;
            color: #ffffff;
            border-color: #f43f5e;
        }

        [data-theme="dark"] .btn-action-delete {
            background: rgba(148, 163, 184, 0.1);
            color: #94a3b8;
            border-color: rgba(148, 163, 184, 0.22);
        }
        [data-theme="dark"] .btn-action-delete:hover {
            background: #ef4444;
            color: #ffffff;
            border-color: #ef4444;
        }

        /* REPORT BOX (CLEAN WHITE WITH MONOSPACE TEXT) */
        .report-box {
            background-color: #ffffff !important;
            color: #111827 !important;
            border: 1px solid #d1d5db !important;
            border-radius: 14px;
            padding: 1.75rem;
            font-family: 'JetBrains Mono', Consolas, 'Courier New', monospace;
            font-size: 0.85rem;
            line-height: 1.65;
            white-space: pre-wrap;
            word-break: break-word;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.03);
            max-height: 600px;
            overflow-y: auto;
            margin: 0;
        }

        /* FORM CONTROLS */
        .form-label-clean {
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            color: var(--txt-muted);
            margin-bottom: 0.45rem;
            display: block;
        }
        .form-control-clean, .form-select-clean {
            background-color: var(--card);
            border: 1px solid var(--border);
            color: var(--txt);
            border-radius: 10px;
            padding: 0.6rem 0.95rem;
            font-size: 0.88rem;
            width: 100%;
            transition: all 0.2s ease;
        }
        .form-control-clean:focus, .form-select-clean:focus {
            outline: none;
            border-color: var(--txt);
            box-shadow: 0 0 0 1px var(--txt);
        }

        /* MODALS */
        .modal-content {
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--txt);
            box-shadow: var(--shadow-modal);
            overflow: hidden;
        }
        .modal-header {
            padding: 1.5rem 1.75rem;
            border-bottom: 1px solid var(--border);
            background: var(--card);
        }
        .modal-title {
            font-weight: 800;
            font-size: 1.15rem;
            letter-spacing: -0.02em;
            text-transform: uppercase;
            color: var(--txt);
        }
        .modal-body {
            padding: 1.75rem;
        }
        .modal-footer {
            padding: 1.25rem 1.75rem;
            border-top: 1px solid var(--border);
            background: var(--card);
        }

        @media (max-width: 992px) {
            .sidebar-rail { display: none; }
            .main-content { margin-left: 0; width: 100%; padding: 1.5rem; }
            .hero-ev { height: auto; padding: 2rem; }
            .hero-ev-title { font-size: 1.8rem; }
        }
    </style>
</head>
<body>

    <!-- 1. SIDEBAR RAIL -->
    <aside class="sidebar-rail">
        <!-- Upper Account Details Changes -->
        <a href="javascript:void(0)" onclick="openAccountModal()" class="brand-logo-icon" title="My Account & Profile Details">
            <i class="bi bi-person-circle"></i>
        </a>

        <!-- 4 Depot Interfaces Navigation -->
        <ul class="sidebar-nav">
            <!-- 1. Depot Dashboard -->
            <li>
                <a href="/inventory/dashboard" class="sidebar-icon-link" title="Depot Dashboard">
                    <i class="bi bi-speedometer2"></i>
                </a>
            </li>
            <!-- 2. Stock Repository -->
            <li>
                <a href="/inventory" class="sidebar-icon-link" title="Stock Repository">
                    <i class="bi bi-layers-fill"></i>
                </a>
            </li>
            <!-- 3. Reorder Alerts -->
            <li>
                <a href="/reorder" class="sidebar-icon-link" title="Reorder Center">
                    <i class="bi bi-bell-fill"></i>
                    <c:if test="${lowStockCount > 0}">
                        <span class="badge-dot"></span>
                    </c:if>
                </a>
            </li>
            <!-- 4. Reports & Audits (Active) -->
            <li>
                <a href="/inventory/reports" class="sidebar-icon-link active" title="Reports & Audits">
                    <i class="bi bi-file-earmark-bar-graph-fill"></i>
                </a>
            </li>
        </ul>

        <!-- Lower Controls: Theme Toggle & Logout -->
        <div class="sidebar-bottom">
            <button class="theme-toggle-sidebar" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                <i class="bi bi-moon-stars-fill" id="themeSideIcon"></i>
            </button>
            <a href="/logout" class="logout-icon-link" title="Sign Out">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </aside>

    <!-- 2. MAIN CONTENT -->
    <main class="main-content">

        <!-- Topbar -->
        <header class="topbar-clean">
            <div>
                <h1 class="topbar-title">EXECUTIVE AUDIT &amp; TELEMETRY</h1>
                <p class="topbar-sub">CERTIFIED INVENTORY VALUATION &amp; ADMINISTRATIVE REPORTING</p>
            </div>

            <div class="d-flex align-items-center gap-3">
                <button type="button" class="btn-pill-outline" onclick="openAccountModal()" title="Account Profile">
                    <i class="bi bi-person-circle"></i>
                    <span>${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}</span>
                </button>
                <button type="button" class="btn-pill-outline" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                    <i id="themeIcon" class="bi bi-moon-stars-fill"></i>
                </button>
                <a href="/inventory/dashboard" class="btn-pill-dark">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </div>
        </header>

        <!-- Flash Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-4 py-3 px-4 border" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <div class="small fw-semibold text-success">${successMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-4 py-3 px-4 border" role="alert">
                <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                <div class="small fw-semibold text-danger">${errorMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Hero Banner -->
        <section class="hero-ev">
            <img src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1600&q=80" alt="Telemetry Cockpit" class="hero-ev-bg">
            <div class="hero-ev-overlay"></div>
            
            <div class="hero-ev-content">
                <div class="hero-metrics-strip">
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${totalItems}</span>
                        <span class="hero-metric-lbl">Catalog SKUs</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${totalStock}</span>
                        <span class="hero-metric-lbl">Depot Units</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">Rs. <fmt:formatNumber value="${totalValuation}" pattern="#,##0"/></span>
                        <span class="hero-metric-lbl">Asset Worth</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${submittedReports != null ? submittedReports.size() : 0}</span>
                        <span class="hero-metric-lbl">Dispatched</span>
                    </div>
                </div>

                <h2 class="hero-ev-title">INVENTORY AUDIT INTELLIGENCE</h2>
                <p class="hero-ev-sub">
                    Compile real-time inventory valuations, track depot capacity thresholds, and transmit certified compliance documentation directly to executive administrators.
                </p>

                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <a href="#reportGeneratorSection" class="btn-pill-white">
                        <i class="bi bi-file-earmark-play-fill"></i> Generate Audit
                    </a>
                    <a href="/inventory" class="btn-pill-ghost">
                        <i class="bi bi-table"></i> Repository
                    </a>
                    <a href="/reorder" class="btn-pill-ghost">
                        <i class="bi bi-bell"></i> Reorder Queue
                    </a>
                </div>
            </div>
        </section>

        <!-- 4 KPI Metrics Row -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag">CATALOG MODELS</span>
                        <div class="kpi-icon-pill">
                            <i class="bi bi-boxes"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val">${totalItems}</div>
                        <p class="kpi-subnote">Active registered part SKUs</p>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag">DEPOT STORAGE</span>
                        <div class="kpi-icon-pill">
                            <i class="bi bi-layers-fill"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val">${totalStock}</div>
                        <p class="kpi-subnote">Units of ${maxCapacity} Max (${capacityPct}%)</p>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag">VALUATION</span>
                        <div class="kpi-icon-pill">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val text-success">Rs. <fmt:formatNumber value="${totalValuation}" pattern="#,##0"/></div>
                        <p class="kpi-subnote">Certified inventory asset worth</p>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card" style="border-color:${lowStockCount > 0 ? 'var(--brand-red)' : 'var(--border)'};">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag" style="color:${lowStockCount > 0 ? 'var(--brand-red)' : 'var(--txt-muted)'};">SAFETY STATUS</span>
                        <div class="kpi-icon-pill" style="color:${lowStockCount > 0 ? 'var(--brand-red)' : 'inherit'};">
                            <i class="bi ${lowStockCount > 0 ? 'bi-exclamation-diamond' : 'bi-shield-check'}"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val" style="color:${lowStockCount > 0 ? 'var(--brand-red)' : 'var(--txt)'};">${lowStockCount}</div>
                        <p class="kpi-subnote">${lowStockCount > 0 ? 'Items below reorder threshold' : 'All stock levels optimal'}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- REPORT GENERATOR CARD -->
        <section id="reportGeneratorSection" class="table-card mb-4">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-file-earmark-code"></i> REPORT GENERATION ENGINE
                    </h3>
                    <p class="table-card-sub">Select date range and template to compile telemetry and certified warehouse audits.</p>
                </div>
                <span class="tag-pill"><i class="bi bi-database-check me-1"></i>Live SQL Data Engine</span>
            </div>

            <div class="p-4">
                <form action="/inventory/reports/generate" method="post">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label-clean">Report Category &amp; Template</label>
                            <select name="reportType" class="form-select-clean" required>
                                <option value="Warehouse Inventory Valuation & Stock Summary" ${reportType == 'Warehouse Inventory Valuation & Stock Summary' ? 'selected' : ''}>
                                    Warehouse Inventory Valuation &amp; Stock Summary
                                </option>
                                <option value="Low Stock & Safety Threshold Audit" ${reportType == 'Low Stock & Safety Threshold Audit' ? 'selected' : ''}>
                                    Low Stock &amp; Safety Threshold Audit
                                </option>
                                <option value="Depot Storage Capacity & Rack Utilization" ${reportType == 'Depot Storage Capacity & Rack Utilization' ? 'selected' : ''}>
                                    Depot Storage Capacity &amp; Rack Utilization
                                </option>
                                <option value="QC Inbound Shipments & Quality Analysis" ${reportType == 'QC Inbound Shipments & Quality Analysis' ? 'selected' : ''}>
                                    QC Inbound Shipments &amp; Quality Analysis
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-clean">Period From</label>
                            <input type="date" name="fromDate" value="${fromDate}" class="form-control-clean">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-clean">Period To</label>
                            <input type="date" name="toDate" value="${toDate}" class="form-control-clean">
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <button type="submit" class="btn-pill-dark w-100 justify-content-center" title="Generate Preview">
                                <i class="bi bi-play-fill"></i> Run
                            </button>
                        </div>
                        <div class="col-12">
                            <label class="form-label-clean">Manager Remarks / Summary Notes for Admin</label>
                            <input type="text" name="notes" value="${notes}" class="form-control-clean" placeholder="e.g. Monthly inventory reconciliation completed. Low stock items flagged for restock.">
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!-- LIVE AUDIT PREVIEW (WHEN REPORT IS GENERATED) -->
        <c:if test="${not empty generatedReport}">
            <section class="table-card mb-4" style="border-color:var(--brand-dark);">
                <div class="table-card-header">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="tag-pill" style="font-weight:700;"><i class="bi bi-eye"></i> PREVIEW READY</span>
                        </div>
                        <h3 class="table-card-title">${reportType}</h3>
                        <p class="table-card-sub">Review compiled audit telemetry before dispatching to Executive Administration.</p>
                    </div>

                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <!-- 1. Download TXT -->
                        <form action="/inventory/reports/download-content-txt" method="post" style="margin:0;">
                            <input type="hidden" name="reportTitle" value="${not empty reportTitle ? reportTitle : reportType}">
                            <textarea name="reportContent" style="display:none;"><c:out value="${generatedReport}"/></textarea>
                            <button type="submit" class="btn-pill-outline" style="padding:0.45rem 1rem; font-size:0.78rem;" title="Download plain text file (.txt)">
                                <i class="bi bi-file-earmark-text"></i> Download TXT
                            </button>
                        </form>

                        <!-- 2. Download PDF -->
                        <form action="/inventory/reports/download-content" method="post" style="margin:0;">
                            <input type="hidden" name="reportTitle" value="${not empty reportTitle ? reportTitle : reportType}">
                            <input type="hidden" name="reportType" value="${reportType}">
                            <input type="hidden" name="notes" value="${notes}">
                            <textarea name="reportContent" style="display:none;"><c:out value="${generatedReport}"/></textarea>
                            <button type="submit" class="btn-pill-outline" style="padding:0.45rem 1rem; font-size:0.78rem;" title="Download Official PDF document">
                                <i class="bi bi-file-earmark-pdf"></i> Download PDF
                            </button>
                        </form>

                        <!-- 3. Dispatch to Executive Admin -->
                        <form action="/inventory/reports/dispatch-admin" method="post" style="margin:0;">
                            <input type="hidden" name="reportTitle" value="${not empty reportTitle ? reportTitle : (reportType.concat(' [Audit Report]'))}">
                            <input type="hidden" name="reportType" value="${reportType}">
                            <input type="hidden" name="fromDate" value="${fromDate}">
                            <input type="hidden" name="toDate" value="${toDate}">
                            <input type="hidden" name="notes" value="${notes}">
                            <textarea name="reportContent" style="display:none;"><c:out value="${generatedReport}"/></textarea>
                            <button type="submit" class="btn-pill-red" style="padding:0.45rem 1.15rem; font-size:0.78rem;">
                                <i class="bi bi-send-check"></i> Dispatch to Executive Admin
                            </button>
                        </form>
                    </div>
                </div>

                <div class="p-4">
                    <pre class="report-box">${generatedReport}</pre>
                </div>
            </section>
        </c:if>

        <!-- SUBMITTED COMPLIANCE AUDITS TABLE -->
        <section class="table-card">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-clock-history"></i> TRANSMITTED COMPLIANCE AUDITS
                    </h3>
                    <p class="table-card-sub">Audit reports submitted to Executive Administration and their review status.</p>
                </div>
                <span class="tag-pill">
                    Dispatched: <strong>${submittedReports != null ? submittedReports.size() : 0}</strong>
                </span>
            </div>

            <div class="table-responsive">
                <table class="table-minimal">
                    <thead>
                        <tr>
                            <th style="width:90px;">Ref #</th>
                            <th>Report Title</th>
                            <th>Category</th>
                            <th>Generated Date</th>
                            <th>Dispatcher</th>
                            <th class="text-center">Admin Status</th>
                            <th class="text-center" style="width:160px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty submittedReports}">
                                <tr>
                                    <td colspan="7" class="text-center py-5" style="color:var(--txt2);">
                                        <i class="bi bi-file-earmark-text fs-1 d-block mb-2" style="color:var(--txt-muted);"></i>
                                        <h6 class="fw-bold" style="color:var(--txt);">No Reports Dispatched Yet</h6>
                                        <small style="color:var(--txt2);">Generate an audit report above and click "Dispatch to Executive Admin" to begin.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="rep" items="${submittedReports}">
                                    <tr>
                                        <td><span class="tag-pill">#${rep.reportId}</span></td>
                                        <td>
                                            <div class="fw-bold" style="color:var(--txt);">${rep.reportTitle}</div>
                                            <c:if test="${not empty rep.notes}">
                                                <small style="color:var(--txt2);"><i class="bi bi-chat-left-text me-1"></i>${rep.notes}</small>
                                            </c:if>
                                        </td>
                                        <td><span class="tag-pill">${rep.reportType}</span></td>
                                        <td><small class="sku-code" style="color:var(--txt2);">${rep.generatedDate}</small></td>
                                        <td><span class="small fw-semibold" style="color:var(--txt);">${rep.generatedBy}</span></td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${rep.status == 'Approved'}">
                                                    <span class="badge-status-approved">
                                                        <i class="bi bi-check-circle-fill"></i> Approved
                                                    </span>
                                                </c:when>
                                                <c:when test="${rep.status == 'Reviewed' || rep.status == 'Reviewed & Analyzed'}">
                                                    <span class="badge-status-reviewed">
                                                        <i class="bi bi-eye-fill"></i> Reviewed
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-status-pending">
                                                        <i class="bi bi-hourglass-split"></i> Pending
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-2 align-items-center">
                                                <button class="btn-action-view"
                                                        onclick="viewModalReport('${rep.reportId}', '${rep.reportTitle}', '${rep.status}')"
                                                        title="View Report Content">
                                                    <i class="bi bi-eye-fill"></i>
                                                </button>
                                                <a href="/inventory/reports/download-txt/${rep.reportId}"
                                                   class="btn-action-txt"
                                                   title="Download Plain Text (.txt)">
                                                    <i class="bi bi-file-earmark-text-fill"></i>
                                                </a>
                                                <a href="/inventory/reports/download/${rep.reportId}"
                                                   class="btn-action-pdf"
                                                   title="Download Official PDF Report">
                                                    <i class="bi bi-file-earmark-pdf-fill"></i>
                                                </a>
                                                <form action="/inventory/reports/delete" method="post" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete this report?');">
                                                    <input type="hidden" name="reportId" value="${rep.reportId}">
                                                    <button type="submit" class="btn-action-delete" title="Delete Report">
                                                        <i class="bi bi-trash3-fill"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <div id="report-content-${rep.reportId}" style="display:none;"><c:out value="${rep.reportContent}"/></div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <!-- View Report Modal -->
    <div class="modal fade" id="viewReportModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <h6 class="modal-title mb-0" id="viewModalTitle">Report Content</h6>
                        <small style="color:var(--txt-muted);" id="viewModalRef"></small>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <pre class="report-box mb-0" id="viewModalBody"></pre>
                </div>
                <div class="modal-footer">
                    <span class="badge-status-approved" id="viewModalStatus"></span>
                    <a id="viewModalDownloadTxtBtn" href="#" class="btn-pill-outline ms-auto" style="padding:0.45rem 1rem; font-size:0.8rem;" title="Download plain text file">
                        <i class="bi bi-file-earmark-text"></i> Download TXT
                    </a>
                    <a id="viewModalDownloadBtn" href="#" class="btn-pill-dark" style="padding:0.45rem 1rem; font-size:0.8rem;">
                        <i class="bi bi-file-earmark-pdf"></i> Download PDF
                    </a>
                    <button type="button" class="btn-pill-outline" style="padding:0.45rem 1rem; font-size:0.8rem;" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- My Account Modal -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width:440px;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center gap-2">
                        <div style="width:38px;height:38px;border-radius:10px;background:var(--card-subtle);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:var(--txt);">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <div>
                            <h6 class="modal-title mb-0">My Account Profile</h6>
                            <small style="color:var(--txt-muted);">Inventory Manager credentials</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <div style="width:64px;height:64px;border-radius:50%;background:var(--card-subtle);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:2rem;color:var(--txt);margin:0 auto .75rem;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div class="fw-bold" style="color:var(--txt);">${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}</div>
                        <div class="small text-secondary">${sessionScope.currentUser} &middot; <span class="tag-pill">Inventory Manager</span></div>
                    </div>

                    <form action="/account/update-profile" method="post" id="profileUpdateForm" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/inventory/reports">

                        <div class="mb-3">
                            <label class="form-label-clean">Full Name</label>
                            <input type="text" name="fullName" class="form-control-clean"
                                   value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}"
                                   placeholder="Your full name" autocomplete="off">
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean">Email Address</label>
                            <input type="email" name="email" class="form-control-clean"
                                   value="${not empty sessionScope.email ? sessionScope.email : 'inventory@parttrack.com'}"
                                   placeholder="your@email.com" autocomplete="off">
                        </div>

                        <hr class="my-3" style="border-color:var(--border);">
                        <p class="small text-secondary mb-3"><i class="bi bi-lock me-1"></i>Change Password <span class="text-muted">(leave blank to keep current)</span></p>

                        <div class="mb-3">
                            <label class="form-label-clean">New Password</label>
                            <div class="input-group">
                                <input type="password" name="newPassword" id="profileNewPass" class="form-control-clean" style="border-top-right-radius:0; border-bottom-right-radius:0;"
                                       placeholder="Min 4 characters" minlength="4" autocomplete="new-password">
                                <button class="btn btn-outline-secondary border-start-0" type="button" style="border-color:var(--border); background:var(--card-subtle);"
                                        onclick="togglePassVisibility('profileNewPass','profilePassIcon')">
                                    <i class="bi bi-eye" id="profilePassIcon"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean">Confirm New Password</label>
                            <input type="password" name="confirmNewPassword" id="profileConfirmPass" class="form-control-clean"
                                   placeholder="Re-enter new password" autocomplete="new-password">
                            <span id="profilePassError" class="text-danger small fw-bold mt-1" style="display:none;"></span>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="button" class="btn-pill-outline flex-fill justify-content-center" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn-pill-dark flex-fill justify-content-center" onclick="return validateProfileForm()">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
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

        function validateProfileForm() {
            var newPass = document.getElementById('profileNewPass').value;
            var confPass = document.getElementById('profileConfirmPass').value;
            var err = document.getElementById('profilePassError');
            err.style.display = 'none';

            if (newPass.length > 0 && newPass.length < 4) {
                err.textContent = 'Password must be at least 4 characters.';
                err.style.display = 'block';
                return false;
            }
            if (newPass !== confPass) {
                err.textContent = 'Passwords do not match.';
                err.style.display = 'block';
                return false;
            }
            return true;
        }

        function viewModalReport(id, title, status) {
            document.getElementById('viewModalTitle').textContent = title;
            document.getElementById('viewModalRef').textContent = "Reference ID #" + id;
            var statusEl = document.getElementById('viewModalStatus');
            statusEl.textContent = status;
            if (status === 'Approved') {
                statusEl.className = 'badge-status-approved';
            } else if (status.includes('Reviewed')) {
                statusEl.className = 'badge-status-reviewed';
            } else {
                statusEl.className = 'badge-status-pending';
            }
            var contentEl = document.getElementById('report-content-' + id);
            document.getElementById('viewModalBody').textContent = contentEl ? contentEl.textContent : "No content";
            var dlBtn = document.getElementById('viewModalDownloadBtn');
            if (dlBtn) dlBtn.href = '/inventory/reports/download/' + id;
            var dlTxtBtn = document.getElementById('viewModalDownloadTxtBtn');
            if (dlTxtBtn) dlTxtBtn.href = '/inventory/reports/download-txt/' + id;
            new bootstrap.Modal(document.getElementById('viewReportModal')).show();
        }

        function toggleTheme() {
            const html = document.documentElement;
            const isDark = html.getAttribute('data-theme') === 'dark';
            const next = isDark ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            const moonClass = 'bi bi-moon-stars-fill';
            const sunClass  = 'bi bi-sun-fill';
            const si = document.getElementById('themeSideIcon');
            const ti = document.getElementById('themeIcon');
            if (si) si.className = next === 'dark' ? sunClass : moonClass;
            if (ti) ti.className = next === 'dark' ? sunClass : moonClass;
        }

        (function() {
            const saved = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', saved);
            window.addEventListener('DOMContentLoaded', function() {
                const si = document.getElementById('themeSideIcon');
                const ti = document.getElementById('themeIcon');
                if (si) si.className = saved === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
                if (ti) ti.className = saved === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
            });
        })();
    </script>
</body>
</html>
