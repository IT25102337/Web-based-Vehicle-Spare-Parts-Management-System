<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoParts | Genuine Vehicle Spare Parts &amp; Accessories</title>
    
    <!-- Dark/Light Theme Initialization BEFORE Render -->
    <script>
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', s);
        })();
    </script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --brand-red: #cc1d24;
            --brand-red-hover: #b0151b;
            --brand-red-soft: #fee2e2;
            --topbar-bg: #f8f9fa;
            --header-bg: #ffffff;
            --bg-page: #f8fafc;
            --card-bg: #ffffff;
            --card-border: #e2e8f0;
            --txt-main: #0f172a;
            --txt-muted: #64748b;
            --txt-light: #94a3b8;
            --input-bg: #f1f5f9;
            --modal-bg: #ffffff;
            --offcanvas-bg: #ffffff;
        }

        [data-theme='dark'] {
            --brand-red: #e11d48;
            --brand-red-hover: #f43f5e;
            --brand-red-soft: #4c0519;
            --topbar-bg: #090d16;
            --header-bg: #0f172a;
            --bg-page: #0b1120;
            --card-bg: #1e293b;
            --card-border: #334155;
            --txt-main: #f8fafc;
            --txt-muted: #94a3b8;
            --txt-light: #64748b;
            --input-bg: #1e293b;
            --modal-bg: #1e293b;
            --offcanvas-bg: #1e293b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-page);
            color: var(--txt-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        /* ── TOP UTILITY BAR ── */
        .utility-topbar {
            background-color: var(--topbar-bg);
            border-bottom: 1px solid var(--card-border);
            font-size: 0.8rem;
            color: var(--txt-muted);
            padding: 0.45rem 2.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .utility-left {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .utility-left a {
            color: var(--txt-muted);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .utility-promo {
            font-weight: 600;
            color: var(--txt-main);
            letter-spacing: 0.01em;
        }

        .utility-right {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .utility-right a, .utility-right span {
            color: var(--txt-muted);
            text-decoration: none;
            cursor: pointer;
        }

        .theme-toggle-btn {
            background: none;
            border: none;
            color: var(--txt-muted);
            cursor: pointer;
            padding: 0;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.8rem;
            font-weight: 600;
        }

        /* ── MAIN HEADER & NAVIGATION ── */
        .site-header {
            background-color: var(--header-bg);
            border-bottom: 1px solid var(--card-border);
            padding: 1rem 2.5rem;
            position: sticky;
            top: 0;
            z-index: 1030;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
        }

        /* Brand Logo with Red Car Emblem */
        .brand-logo-link {
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.65rem;
            line-height: 1;
        }

        .brand-car-icon {
            font-size: 1.9rem;
            color: var(--brand-red);
            display: inline-block;
            transform: translateY(-1px);
        }

        .brand-text-block {
            display: flex;
            flex-direction: column;
        }

        .brand-name {
            font-size: 1.6rem;
            font-weight: 900;
            letter-spacing: -0.04em;
            color: var(--txt-main);
            text-transform: uppercase;
        }

        .brand-name span {
            color: var(--brand-red);
        }

        .brand-tagline {
            font-size: 0.62rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--txt-muted);
        }

        /* Center Nav Links */
        .nav-links-menu {
            display: flex;
            align-items: center;
            gap: 2rem;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .nav-link-item a {
            color: var(--txt-main);
            font-weight: 600;
            font-size: 0.92rem;
            text-decoration: none;
            transition: color 0.18s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .nav-link-item a:hover, .nav-link-item.active a {
            color: var(--brand-red);
        }

        /* Header Right Action Icons */
        .header-actions {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .header-icon-btn {
            background: none;
            border: none;
            color: var(--txt-main);
            font-size: 1.2rem;
            cursor: pointer;
            position: relative;
            padding: 0.35rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: color 0.15s ease, transform 0.15s ease;
            text-decoration: none;
        }

        .header-icon-btn:hover {
            color: var(--brand-red);
            transform: scale(1.08);
        }

        .header-badge-count {
            position: absolute;
            top: -2px;
            right: -4px;
            background-color: var(--brand-red);
            color: #ffffff;
            font-size: 0.68rem;
            font-weight: 800;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 5px rgba(204, 29, 36, 0.4);
        }

        .header-user-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background: var(--input-bg);
            border: 1px solid var(--card-border);
            padding: 0.4rem 0.85rem;
            border-radius: 99px;
            font-size: 0.84rem;
            font-weight: 600;
            color: var(--txt-main);
            text-decoration: none;
            transition: all 0.15s;
        }

        .header-user-pill:hover {
            background: var(--card-border);
            color: var(--brand-red);
        }

        /* ── FLOATING RIGHT CART TAB (AS SHOWN IN REFERENCE) ── */
        .floating-cart-widget {
            position: fixed;
            right: 0;
            top: 210px;
            background-color: var(--brand-red);
            color: #ffffff;
            padding: 0.65rem 0.95rem;
            border-radius: 8px 0 0 8px;
            box-shadow: -4px 6px 18px rgba(204, 29, 36, 0.35);
            z-index: 1020;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-weight: 700;
            font-size: 0.84rem;
            transition: transform 0.2s ease, background-color 0.15s ease;
        }

        .floating-cart-widget:hover {
            transform: translateX(-4px);
            background-color: var(--brand-red-hover);
        }

        /* ── HERO CAROUSEL SHOWCASE (RED ASTON MARTIN & PORSCHE 911 GT3) ── */
        .hero-carousel-container {
            position: relative;
            background-color: #0b0f19;
            overflow: hidden;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .hero-slide {
            position: relative;
            min-height: 520px;
            display: flex;
            align-items: center;
            padding: 4rem 4rem;
            background-position: center right;
            background-repeat: no-repeat;
            background-size: cover;
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
        }

        .hero-slide-1 {
            background-image: 
                linear-gradient(90deg, rgba(11, 15, 25, 0.96) 0%, rgba(11, 15, 25, 0.85) 42%, rgba(11, 15, 25, 0.28) 75%, rgba(11, 15, 25, 0.88) 100%),
                url('/images/hero_red_car.jpg');
        }

        .hero-slide-2 {
            background-image: 
                linear-gradient(90deg, rgba(11, 15, 25, 0.96) 0%, rgba(11, 15, 25, 0.82) 45%, rgba(11, 15, 25, 0.22) 75%, rgba(11, 15, 25, 0.9) 100%),
                url('https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=1920&q=85');
        }

        .hero-slide-3 {
            background-image: 
                linear-gradient(90deg, rgba(11, 15, 25, 0.96) 0%, rgba(11, 15, 25, 0.84) 42%, rgba(11, 15, 25, 0.22) 75%, rgba(11, 15, 25, 0.92) 100%),
                url('https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?auto=format&fit=crop&w=1920&q=85');
        }

        .hero-slide-4 {
            background-image: 
                linear-gradient(90deg, rgba(11, 15, 25, 0.96) 0%, rgba(11, 15, 25, 0.84) 42%, rgba(11, 15, 25, 0.22) 75%, rgba(11, 15, 25, 0.92) 100%),
                url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1920&q=85');
        }

        .hero-content-box {
            max-width: 620px;
            position: relative;
            z-index: 2;
        }

        .hero-tag-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.35rem 0.95rem;
            background: rgba(204, 29, 36, 0.18);
            border: 1px solid rgba(204, 29, 36, 0.45);
            color: #ff6b72;
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            border-radius: 9999px;
            margin-bottom: 1.25rem;
            backdrop-filter: blur(8px);
        }

        .hero-main-title {
            font-size: 3.5rem;
            font-weight: 900;
            line-height: 1.1;
            letter-spacing: -0.035em;
            color: #ffffff;
            margin-bottom: 1.1rem;
        }

        .hero-main-title span {
            display: block;
        }

        .hero-desc {
            font-size: 1.05rem;
            color: #cbd5e1;
            margin-bottom: 2.2rem;
            line-height: 1.6;
            font-weight: 400;
        }

        .btn-shop-now {
            background-color: var(--brand-red);
            color: #ffffff;
            font-weight: 800;
            font-size: 0.92rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            padding: 0.9rem 2.5rem;
            border-radius: 6px;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            text-decoration: none;
            box-shadow: 0 8px 24px rgba(204, 29, 36, 0.45);
            transition: all 0.2s ease;
        }

        .btn-shop-now:hover {
            background-color: var(--brand-red-hover);
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 14px 32px rgba(204, 29, 36, 0.6);
        }

        /* Carousel Navigation Controls */
        .hero-carousel-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            cursor: pointer;
            z-index: 10;
            transition: all 0.2s ease;
            backdrop-filter: blur(8px);
        }

        .hero-carousel-btn:hover {
            background: var(--brand-red);
            border-color: var(--brand-red);
            color: #ffffff;
            transform: translateY(-50%) scale(1.08);
        }

        .hero-carousel-prev { left: 24px; }
        .hero-carousel-next { right: 24px; }

        .hero-indicators-strip {
            position: absolute;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 0.6rem;
            z-index: 10;
        }

        .hero-indicator-dot {
            width: 10px;
            height: 10px;
            border-radius: 9999px;
            background: rgba(255, 255, 255, 0.35);
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 0;
        }

        .hero-indicator-dot.active {
            width: 32px;
            background: var(--brand-red);
            box-shadow: 0 0 10px rgba(204, 29, 36, 0.7);
        }

        /* ── 4 FEATURE HIGHLIGHTS STRIP ── */
        .features-strip {
            background-color: var(--card-bg);
            border-bottom: 1px solid var(--card-border);
            padding: 2.2rem 2.5rem;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            max-width: 1300px;
            margin: 0 auto;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .feature-icon-box {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background-color: var(--brand-red-soft);
            color: var(--brand-red);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
            border: 1px solid rgba(204, 29, 36, 0.15);
        }

        .feature-title {
            font-size: 0.98rem;
            font-weight: 800;
            color: var(--txt-main);
            margin-bottom: 0.15rem;
        }

        .feature-sub {
            font-size: 0.82rem;
            color: var(--txt-muted);
            margin: 0;
        }

        /* ── POPULAR CATEGORIES SECTION (PROFESSIONAL CARDS) ── */
        .section-popular-categories {
            padding: 4.5rem 2.5rem 3rem 2.5rem;
            max-width: 1380px;
            margin: 0 auto;
            width: 100%;
        }

        .categories-header-center {
            text-align: center;
            margin-bottom: 3rem;
        }

        .categories-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.4rem 1.1rem;
            background: rgba(204, 29, 36, 0.08);
            color: var(--brand-red);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.09em;
            text-transform: uppercase;
            border-radius: 9999px;
            margin-bottom: 0.85rem;
            border: 1px solid rgba(204, 29, 36, 0.22);
        }

        .categories-title {
            font-size: 2.1rem;
            font-weight: 900;
            letter-spacing: -0.025em;
            text-transform: uppercase;
            color: var(--txt-main);
            margin: 0 0 0.5rem 0;
            line-height: 1.2;
        }

        .category-underline-bar {
            width: 50px;
            height: 3px;
            background: var(--brand-red);
            margin: 0.6rem auto 1rem;
            border-radius: 99px;
        }

        .categories-sub {
            font-size: 0.95rem;
            color: var(--txt-muted);
            margin: 0 auto;
            max-width: 640px;
            line-height: 1.6;
        }

        .categories-bento-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
        }

        .category-bento-card {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            display: flex;
            align-items: center;
            padding: 1.85rem 1.65rem;
            gap: 1.5rem;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.04);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .category-bento-card::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: 20px;
            border: 2px solid transparent;
            transition: border-color 0.25s ease;
            pointer-events: none;
        }

        .category-bento-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px -6px rgba(0, 0, 0, 0.12);
        }

        .category-bento-card:hover::before {
            border-color: var(--brand-red);
        }

        .category-thumb-wrap {
            width: 130px;
            height: 130px;
            position: relative;
            flex-shrink: 0;
            border-radius: 16px;
            overflow: hidden;
            background: linear-gradient(135deg, #1e293b, #0f172a);
            box-shadow: 0 8px 18px rgba(0, 0, 0, 0.15);
        }

        .category-thumb-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .category-bento-card:hover .category-thumb-wrap img {
            transform: scale(1.12);
        }

        .category-discount-pill {
            position: absolute;
            top: 8px;
            left: 8px;
            background-color: var(--brand-red);
            color: #ffffff;
            font-size: 0.68rem;
            font-weight: 800;
            padding: 3px 9px;
            border-radius: 9999px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            box-shadow: 0 3px 8px rgba(204, 29, 36, 0.45);
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            z-index: 2;
        }

        .category-info-col {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .category-card-name {
            font-size: 1.3rem;
            font-weight: 800;
            letter-spacing: -0.025em;
            color: var(--txt-main);
            margin-bottom: 0.65rem;
            line-height: 1.25;
            transition: color 0.2s ease;
        }

        .category-bento-card:hover .category-card-name {
            color: var(--brand-red);
        }

        .category-sublist {
            list-style: none;
            padding: 0;
            margin: 0 0 1.15rem 0;
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .category-sublist li {
            position: relative;
            padding-left: 1.1rem;
        }

        .category-sublist li::before {
            content: '•';
            position: absolute;
            left: 0.2rem;
            color: var(--brand-red);
            font-size: 1.1rem;
            line-height: 1;
        }

        .category-sublist li a {
            font-size: 0.88rem;
            color: var(--txt-muted);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.15s ease, transform 0.15s ease;
            display: inline-block;
        }

        .category-sublist li a:hover {
            color: var(--brand-red);
            transform: translateX(3px);
        }

        .category-show-all-btn {
            font-size: 0.84rem;
            font-weight: 800;
            color: var(--brand-red);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            letter-spacing: 0.02em;
            transition: gap 0.2s ease, color 0.2s ease;
            margin-top: auto;
        }

        .category-bento-card:hover .category-show-all-btn {
            gap: 0.75rem;
            color: var(--brand-red-hover);
        }

        /* ── INVENTORY PRODUCT CATALOG SECTION ── */
        .catalog-section {
            padding: 2.5rem 2.5rem 5rem 2.5rem;
            max-width: 1350px;
            margin: 0 auto;
            width: 100%;
        }

        .catalog-header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-bottom: 2.25rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--card-border);
        }

        .catalog-title-group h3 {
            font-size: 1.65rem;
            font-weight: 900;
            letter-spacing: -0.02em;
            color: var(--txt-main);
            margin: 0;
            text-transform: uppercase;
        }

        .catalog-title-group p {
            font-size: 0.88rem;
            color: var(--txt-muted);
            margin: 0.35rem 0 0 0;
        }

        /* Filter Tabs */
        .category-filter-nav {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .cat-filter-btn {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            color: var(--txt-muted);
            font-size: 0.82rem;
            font-weight: 700;
            padding: 0.5rem 1.15rem;
            border-radius: 9999px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .cat-filter-btn:hover {
            color: var(--txt-main);
            border-color: var(--txt-main);
            background: var(--topbar-bg);
        }

        .cat-filter-btn.active {
            background-color: var(--brand-dark);
            border-color: var(--brand-dark);
            color: #ffffff;
        }
        [data-theme="dark"] .cat-filter-btn.active {
            background-color: #ffffff;
            border-color: #ffffff;
            color: #09090b;
        }

        /* Search Bar */
        .catalog-search-wrap {
            max-width: 300px;
            width: 100%;
            position: relative;
        }

        .catalog-search-input {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 9999px;
            padding: 0.55rem 1rem 0.55rem 2.4rem;
            font-size: 0.86rem;
            color: var(--txt-main);
            width: 100%;
            outline: none;
            transition: all 0.2s ease;
        }

        .catalog-search-input:focus {
            border-color: var(--brand-red);
            box-shadow: 0 0 0 1px var(--brand-red);
        }

        .catalog-search-icon {
            position: absolute;
            left: 0.85rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--txt-muted);
            pointer-events: none;
            font-size: 0.9rem;
        }

        /* ── PRODUCT CARDS GRID (PREMIUM AUTOMOTIVE CUSTOMER SELECTION BOXES) ── */
        .products-showcase-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.75rem;
        }

        .product-item-card {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 1.85rem 1.65rem 1.65rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.04);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
            min-height: 310px;
        }

        .product-item-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--brand-red) 0%, #f43f5e 100%);
            opacity: 0;
            transition: opacity 0.25s ease;
        }

        .product-item-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px -8px rgba(0, 0, 0, 0.12);
            border-color: rgba(204, 29, 36, 0.45);
        }

        .product-item-card:hover::before {
            opacity: 1;
        }

        /* Top Header inside card: Category Icon & Stock Pill */
        .product-card-top-spec {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
            margin-bottom: 1.35rem;
        }

        .part-icon-box {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            background: var(--topbar-bg);
            border: 1px solid var(--card-border);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.04);
            padding: 8px;
            overflow: hidden;
            position: relative;
        }

        .part-vector-icon {
            width: 44px;
            height: 44px;
            object-fit: contain;
            transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1), filter 0.25s ease;
            display: block;
        }

        /* Light mode vector tinting */
        [data-theme='light'] .part-vector-icon {
            filter: brightness(0) saturate(100%) invert(18%) sepia(21%) saturate(2324%) hue-rotate(180deg) brightness(92%) contrast(92%);
        }

        /* Dark mode vector tinting: clean bright white-silver */
        [data-theme='dark'] .part-vector-icon {
            filter: brightness(0) saturate(100%) invert(94%) sepia(8%) saturate(180%) hue-rotate(185deg) brightness(102%) contrast(97%);
        }

        .product-item-card:hover .part-icon-box {
            background: var(--brand-red-soft);
            border-color: rgba(204, 29, 36, 0.45);
            transform: scale(1.08) rotate(-2deg);
            box-shadow: 0 10px 22px rgba(204, 29, 36, 0.22);
        }

        .product-item-card:hover .part-vector-icon {
            transform: scale(1.1);
            filter: brightness(0) saturate(100%) invert(18%) sepia(84%) saturate(4645%) hue-rotate(349deg) brightness(84%) contrast(95%) !important;
        }

        .stock-badge-tag {
            font-size: 0.75rem;
            font-weight: 800;
            padding: 6px 14px;
            border-radius: 9999px;
            letter-spacing: 0.03em;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .tag-in-stock {
            background-color: rgba(16, 185, 129, 0.12);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .tag-low-stock {
            background-color: rgba(245, 158, 11, 0.12);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.25);
        }

        .tag-out-stock {
            background-color: rgba(239, 68, 68, 0.12);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .part-category-tag {
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--brand-red);
            margin-bottom: 0.45rem;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .product-name-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--txt-main);
            margin-bottom: 0.85rem;
            line-height: 1.3;
            letter-spacing: -0.02em;
            transition: color 0.2s ease;
        }

        .product-item-card:hover .product-name-title {
            color: var(--brand-red);
        }

        .product-meta-specs {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .meta-pill-tag {
            font-size: 0.74rem;
            font-weight: 700;
            color: var(--txt-muted);
            background: var(--topbar-bg);
            border: 1px solid var(--card-border);
            padding: 0.35rem 0.8rem;
            border-radius: 9999px;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .meta-pill-tag {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--txt-muted);
            background: var(--topbar-bg);
            border: 1px solid var(--card-border);
            padding: 0.3rem 0.75rem;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .product-card-footer {
            margin-top: auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 1.25rem;
            border-top: 1px solid var(--card-border);
            gap: 0.75rem;
        }

        .product-price-val {
            display: flex;
            flex-direction: column;
            line-height: 1.1;
        }

        .product-price-label {
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--txt-muted);
            margin-bottom: 2px;
        }

        .product-price-amount {
            font-size: 1.4rem;
            font-weight: 900;
            color: var(--brand-red);
            font-family: 'JetBrains Mono', monospace;
            letter-spacing: -0.03em;
        }

        .product-btn-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-card-add-cart {
            background-color: var(--topbar-bg);
            border: 1.5px solid var(--card-border);
            color: var(--txt-main);
            font-size: 0.84rem;
            font-weight: 700;
            padding: 0.52rem 1rem;
            border-radius: 9999px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-card-add-cart:hover {
            background-color: var(--brand-dark);
            border-color: var(--brand-dark);
            color: #ffffff;
            transform: translateY(-1px);
        }
        [data-theme="dark"] .btn-card-add-cart:hover {
            background-color: #ffffff;
            border-color: #ffffff;
            color: #09090b;
        }

        .btn-card-buy-now {
            background-color: var(--brand-red);
            border: 1.5px solid var(--brand-red);
            color: #ffffff;
            font-size: 0.84rem;
            font-weight: 800;
            padding: 0.52rem 1.15rem;
            border-radius: 9999px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            box-shadow: 0 4px 12px rgba(204, 29, 36, 0.3);
        }

        .btn-card-buy-now:hover {
            background-color: var(--brand-red-hover);
            border-color: var(--brand-red-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(204, 29, 36, 0.45);
        }

        /* ── FOOTER ── */
        .site-footer {
            background-color: #0b0f19;
            color: #94a3b8;
            padding: 3rem 2.5rem 1.5rem 2.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            margin-top: auto;
        }

        .footer-content-wrap {
            max-width: 1300px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 2.5rem;
            margin-bottom: 2.5rem;
        }

        .footer-brand-title {
            color: #ffffff;
            font-size: 1.4rem;
            font-weight: 900;
            margin-bottom: 0.75rem;
        }

        .footer-brand-title span {
            color: var(--brand-red);
        }

        .footer-col h6 {
            color: #ffffff;
            font-size: 0.92rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .footer-col ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            font-size: 0.85rem;
        }

        .footer-col ul li a {
            color: #94a3b8;
            text-decoration: none;
            transition: color 0.15s ease;
        }

        .footer-col ul li a:hover {
            color: #ffffff;
        }

        .footer-bottom-bar {
            max-width: 1300px;
            margin: 0 auto;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.78rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        /* ── TOAST NOTIFICATION ── */
        .toast-notify {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #0f172a;
            color: #ffffff;
            padding: 0.85rem 1.25rem;
            border-radius: 6px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.35);
            display: none;
            align-items: center;
            gap: 0.65rem;
            z-index: 1060;
            font-size: 0.88rem;
            font-weight: 600;
            border-left: 4px solid var(--brand-red);
        }

        /* ── RESPONSIVE DESIGN ── */
        @media (max-width: 1024px) {
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .categories-bento-grid {
                grid-template-columns: 1fr;
            }
            .footer-content-wrap {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .utility-topbar {
                display: none;
            }
            .site-header {
                padding: 0.85rem 1.25rem;
            }
            .nav-links-menu {
                display: none;
            }
            .hero-showcase {
                padding: 2.5rem 1.5rem;
                min-height: 380px;
            }
            .hero-main-title {
                font-size: 2.2rem;
            }
            .features-grid {
                grid-template-columns: 1fr;
            }
            .section-popular-categories, .catalog-section {
                padding-left: 1.25rem;
                padding-right: 1.25rem;
            }
            .footer-content-wrap {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  1. TOP UTILITY BAR                               -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="utility-topbar">
        <div class="utility-left">
            <a href="tel:+94112345678">
                <i class="bi bi-telephone text-danger"></i> Call Us: +94 11 234 5678
            </a>
            <span>&bull;</span>
            <span class="utility-promo">15% OFF EVERY GENUINE SPARE PART — DEPOT EXPRESS DISPATCH</span>
        </div>
        <div class="utility-right">
            <span>English <i class="bi bi-chevron-down small"></i></span>
            <span>Rs. LKR <i class="bi bi-chevron-down small"></i></span>
            <button class="theme-toggle-btn" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                <i id="themeIcon" class="bi bi-moon-stars-fill"></i>
                <span id="themeText">Theme</span>
            </button>
        </div>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  2. MAIN BRAND HEADER & NAVIGATION                -->
    <!-- ═════════════════════════════════════════════════ -->
    <header class="site-header">
        <!-- Logo -->
        <a href="/customer" class="brand-logo-link">
            <i class="bi bi-car-front-fill brand-car-icon"></i>
            <div class="brand-text-block">
                <div class="brand-name">AUTO<span>PARTS</span></div>
                <div class="brand-tagline">Genuine Vehicle Spare Parts</div>
            </div>
        </a>

        <!-- Center Menu -->
        <ul class="nav-links-menu">
            <li class="nav-link-item active"><a href="/customer">Home</a></li>
            <li class="nav-link-item"><a href="javascript:void(0)" onclick="filterCatalogCategory('interiors')">Interiors</a></li>
            <li class="nav-link-item"><a href="javascript:void(0)" onclick="filterCatalogCategory('exteriors')">Exteriors</a></li>
            <li class="nav-link-item"><a href="javascript:void(0)" onclick="filterCatalogCategory('engine')">Performance &amp; Engine</a></li>
            <li class="nav-link-item"><a href="#catalogSection">All Parts</a></li>
        </ul>

        <!-- Right Header Actions -->
        <div class="header-actions">
            <!-- Search trigger -->
            <a href="#catalogSection" onclick="focusCatalogSearch()" class="header-icon-btn" title="Search Inventory">
                <i class="bi bi-search"></i>
            </a>

            <!-- User Account / Profile -->
            <a href="javascript:void(0)" onclick="openAccountModal()" class="header-user-pill" title="My Customer Profile">
                <i class="bi bi-person-circle fs-6 text-danger"></i>
                <span>
                    <c:choose>
                        <c:when test="${not empty sessionScope.fullName}">${sessionScope.fullName}</c:when>
                        <c:when test="${not empty sessionScope.currentUser}">${sessionScope.currentUser}</c:when>
                        <c:otherwise>Sign In</c:otherwise>
                    </c:choose>
                </span>
            </a>

            <!-- Customer Orders & Live Status -->
            <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#myOrdersModal" class="header-icon-btn" title="My Orders & Tracking">
                <i class="bi bi-box-seam"></i>
                <c:choose>
                    <c:when test="${myProcessingCount > 0}">
                        <span class="header-badge-count" style="background:#f59e0b;" title="${myProcessingCount} In Processing">${myProcessingCount}</span>
                    </c:when>
                    <c:when test="${not empty myOrders && myOrders.size() > 0}">
                        <span class="header-badge-count">${myOrders.size()}</span>
                    </c:when>
                </c:choose>
            </a>

            <!-- Shopping Cart Trigger -->
            <button class="header-icon-btn" onclick="toggleCartOffcanvas()" title="Shopping Cart">
                <i class="bi bi-cart3"></i>
                <span class="header-badge-count" id="headerCartCountBadge">0</span>
            </button>

            <!-- Sign Out -->
            <a href="/logout" class="header-icon-btn text-muted" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </header>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  3. FLOATING RIGHT-EDGE CART WIDGET               -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="floating-cart-widget" onclick="toggleCartOffcanvas()" title="View Shopping Cart">
        <i class="bi bi-bag-fill fs-6"></i>
        <span><span id="floatCartCount">0</span> Items</span>
        <span>|</span>
        <span id="floatCartTotal">Rs. 0.00</span>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  4. HERO SHOWCASE: DUAL CAR SLIDES CAROUSEL       -->
    <!-- ═════════════════════════════════════════════════ -->
    <section class="hero-carousel-container" id="heroCarouselWrapper">
        <!-- Slide 1: Aston Martin DBX Red SUV in Garage -->
        <div class="hero-slide hero-slide-1" id="heroSlide1">
            <div class="hero-content-box">
                <div class="hero-tag-badge">
                    <i class="bi bi-stars"></i> PREMIUM OEM AUTOMOTIVE SELECTION
                </div>
                <h1 class="hero-main-title">
                    <span>Get New</span>
                    <span style="color:#ffffff;">Car LED Headlights</span>
                </h1>
                <p class="hero-desc">
                    High-performance certified OEM components, direct factory warranties, and real-time depot inventory dispatch for your vehicle.
                </p>
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <a href="#catalogSection" class="btn-shop-now">
                        SHOP NOW <i class="bi bi-arrow-right"></i>
                    </a>
                    <button type="button" class="btn btn-outline-light rounded-pill px-4 py-2 fw-bold text-uppercase" style="letter-spacing:0.04em;font-size:0.88rem;" onclick="filterCatalogCategory('exteriors')">
                        <i class="bi bi-lightning-charge me-1"></i> Exterior Lighting
                    </button>
                </div>
            </div>
        </div>

        <!-- Slide 2: Porsche 911 GT3 High Performance Supercar -->
        <div class="hero-slide hero-slide-2" id="heroSlide2" style="display:none;">
            <div class="hero-content-box">
                <div class="hero-tag-badge" style="background:rgba(59,130,246,0.18);border-color:rgba(59,130,246,0.45);color:#93c5fd;">
                    <i class="bi bi-speedometer2"></i> TRACK TESTED &amp; MOTORSPORT CERTIFIED
                </div>
                <h1 class="hero-main-title">
                    <span>Performance</span>
                    <span style="color:#ffffff;">Engines &amp; Powertrain</span>
                </h1>
                <p class="hero-desc">
                    Uncompromising engineering precision. Genuine transmission assemblies, forged suspension struts, and high-flow radiators built to OEM endurance tolerances.
                </p>
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <a href="#catalogSection" class="btn-shop-now">
                        EXPLORE POWER <i class="bi bi-arrow-right"></i>
                    </a>
                    <button type="button" class="btn btn-outline-light rounded-pill px-4 py-2 fw-bold text-uppercase" style="letter-spacing:0.04em;font-size:0.88rem;" onclick="filterCatalogCategory('engine')">
                        <i class="bi bi-gear-wide-connected me-1"></i> Powertrain Parts
                    </button>
                </div>
            </div>
        </div>

        <!-- Slide 3: Audi RS Night Runner - Braking & Chassis Dynamics -->
        <div class="hero-slide hero-slide-3" id="heroSlide3" style="display:none;">
            <div class="hero-content-box">
                <div class="hero-tag-badge" style="background:rgba(234,179,8,0.18);border-color:rgba(234,179,8,0.45);color:#fde047;">
                    <i class="bi bi-shield-check"></i> MAXIMUM STOPPING POWER &amp; SAFETY
                </div>
                <h1 class="hero-main-title">
                    <span>Precision</span>
                    <span style="color:#ffffff;">Braking &amp; Suspension</span>
                </h1>
                <p class="hero-desc">
                    Engineered for total control. Carbon-ceramic brake pads, slotted performance rotors, and responsive steering tie-rods direct from certified manufacturers.
                </p>
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <a href="#catalogSection" class="btn-shop-now">
                        UPGRADE BRAKES <i class="bi bi-arrow-right"></i>
                    </a>
                    <button type="button" class="btn btn-outline-light rounded-pill px-4 py-2 fw-bold text-uppercase" style="letter-spacing:0.04em;font-size:0.88rem;" onclick="filterCatalogCategory('exteriors')">
                        <i class="bi bi-disc me-1"></i> Braking &amp; Wheels
                    </button>
                </div>
            </div>
        </div>

        <!-- Slide 4: Luxury Cockpit & Digital Telemetry -->
        <div class="hero-slide hero-slide-4" id="heroSlide4" style="display:none;">
            <div class="hero-content-box">
                <div class="hero-tag-badge" style="background:rgba(16,185,129,0.18);border-color:rgba(16,185,129,0.45);color:#6ee7b7;">
                    <i class="bi bi-cpu-fill"></i> LUXURY COCKPIT &amp; ELECTRONICS
                </div>
                <h1 class="hero-main-title">
                    <span>Smart Cabin</span>
                    <span style="color:#ffffff;">Electronics &amp; Sensors</span>
                </h1>
                <p class="hero-desc">
                    Elevate every journey with factory-certified digital instrument clusters, intelligent lighting controllers, and premium interior climate components.
                </p>
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <a href="#catalogSection" class="btn-shop-now">
                        EXPLORE CABIN <i class="bi bi-arrow-right"></i>
                    </a>
                    <button type="button" class="btn btn-outline-light rounded-pill px-4 py-2 fw-bold text-uppercase" style="letter-spacing:0.04em;font-size:0.88rem;" onclick="filterCatalogCategory('interiors')">
                        <i class="bi bi-sliders me-1"></i> Interior Systems
                    </button>
                </div>
            </div>
        </div>

        <!-- Prev / Next Navigation Arrows -->
        <button type="button" class="hero-carousel-btn hero-carousel-prev" onclick="prevHeroSlide()" title="Previous Supercar Slide">
            <i class="bi bi-chevron-left"></i>
        </button>
        <button type="button" class="hero-carousel-btn hero-carousel-next" onclick="nextHeroSlide()" title="Next Supercar Slide">
            <i class="bi bi-chevron-right"></i>
        </button>

        <!-- Slide Indicators -->
        <div class="hero-indicators-strip">
            <button type="button" class="hero-indicator-dot active" id="heroDot0" onclick="goToHeroSlide(0)" title="Slide 1: Aston Martin DBX"></button>
            <button type="button" class="hero-indicator-dot" id="heroDot1" onclick="goToHeroSlide(1)" title="Slide 2: Porsche 911 GT3"></button>
            <button type="button" class="hero-indicator-dot" id="heroDot2" onclick="goToHeroSlide(2)" title="Slide 3: Audi RS Braking Dynamics"></button>
            <button type="button" class="hero-indicator-dot" id="heroDot3" onclick="goToHeroSlide(3)" title="Slide 4: Luxury Cockpit & Electronics"></button>
        </div>
    </section>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  5. 4 FEATURE HIGHLIGHTS STRIP                    -->
    <!-- ═════════════════════════════════════════════════ -->
    <section class="features-strip">
        <div class="features-grid">
            <!-- 1. Free Shipping -->
            <div class="feature-item">
                <div class="feature-icon-box">
                    <i class="bi bi-truck"></i>
                </div>
                <div>
                    <div class="feature-title">Free Express Shipping</div>
                    <p class="feature-sub">On orders over Rs. 10,000</p>
                </div>
            </div>

            <!-- 2. Support 24/7 -->
            <div class="feature-item">
                <div class="feature-icon-box">
                    <i class="bi bi-headset"></i>
                </div>
                <div>
                    <div class="feature-title">24/7 Expert Support</div>
                    <p class="feature-sub">Vehicle technician hotline</p>
                </div>
            </div>

            <!-- 3. 100% Safety -->
            <div class="feature-item">
                <div class="feature-icon-box">
                    <i class="bi bi-shield-lock"></i>
                </div>
                <div>
                    <div class="feature-title">OEM 100% Authenticity</div>
                    <p class="feature-sub">Verified factory certificates</p>
                </div>
            </div>

            <!-- 4. Hot Offers -->
            <div class="feature-item">
                <div class="feature-icon-box">
                    <i class="bi bi-tag-fill"></i>
                </div>
                <div>
                    <div class="feature-title">Exclusive Deals</div>
                    <p class="feature-sub">Up to 30% depot savings</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  6. POPULAR CATEGORIES SECTION                    -->
    <!-- ═════════════════════════════════════════════════ -->
    <section class="section-popular-categories">
        <div class="categories-header-center">
            <span class="categories-eyebrow"><i class="bi bi-stars"></i> PREMIUM VEHICLE SYSTEMS</span>
            <h2 class="categories-title">POPULAR CATEGORIES</h2>
            <div class="category-underline-bar"></div>
            <p class="categories-sub">Discover high-demand vehicle subsystems and genuine certified factory parts engineered for safety, speed, and endurance.</p>
        </div>

        <div class="categories-bento-grid">
            <!-- Bento Card 1: Interiors -->
            <div class="category-bento-card" onclick="filterCatalogCategory('interiors')">
                <div class="category-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=500&q=80" alt="Cabin Care & Interior Electronics" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=500&q=80';">
                    <span class="category-discount-pill"><i class="bi bi-shield-check"></i> Cabin Care</span>
                </div>
                <div class="category-info-col">
                    <div class="category-card-name">Interiors &amp; Cockpit</div>
                    <ul class="category-sublist">
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('accessories');">Accessories &amp; Comfort</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('suspension');">Suspension Bushings</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('odometer');">Digital Odometers</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('indicator');">Indicator Light Modules</a></li>
                    </ul>
                    <a href="javascript:void(0)" class="category-show-all-btn">
                        Explore Collection <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Bento Card 2: Exteriors -->
            <div class="category-bento-card" onclick="filterCatalogCategory('exteriors')">
                <div class="category-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=500&q=80" alt="Exterior Chassis & Bodywork" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=500&q=80';">
                    <span class="category-discount-pill" style="background:#0284c7;"><i class="bi bi-lightning-fill"></i> Save 15%</span>
                </div>
                <div class="category-info-col">
                    <div class="category-card-name">Exterior &amp; Body</div>
                    <ul class="category-sublist">
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('carburetor');">Fuel Carburetors</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('fuel');">High-Capacity Fuel Cells</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('pitman');">Steering Pitman Arms</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('spring');">Heavy-Duty Coil Springs</a></li>
                    </ul>
                    <a href="javascript:void(0)" class="category-show-all-btn">
                        Explore Collection <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Bento Card 3: Engine -->
            <div class="category-bento-card" onclick="filterCatalogCategory('engine')">
                <div class="category-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=500&q=80" alt="Engine Powertrain Components" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=500&q=80';">
                    <span class="category-discount-pill" style="background:#16a34a;"><i class="bi bi-patch-check-fill"></i> OEM 100%</span>
                </div>
                <div class="category-info-col">
                    <div class="category-card-name">Engine &amp; Powertrain</div>
                    <ul class="category-sublist">
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('transmission');">Transmission Gears</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('alternator');">Heavy-Duty Alternators</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('axle');">Front Axle Assemblies</a></li>
                        <li><a href="javascript:void(0)" onclick="event.stopPropagation(); searchCatalogFor('radiator');">Alloy Cooling Radiators</a></li>
                    </ul>
                    <a href="javascript:void(0)" class="category-show-all-btn">
                        Explore Collection <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  7. LIVE INVENTORY PRODUCT CATALOG                -->
    <!-- ═════════════════════════════════════════════════ -->
    <section class="catalog-section" id="catalogSection">
        
        <!-- Flash messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show py-2 px-3 small rounded-1 mb-4 border d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <div>${successMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show py-2 px-3 small rounded-1 mb-4 border d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                <div>${errorMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Header controls -->
        <div class="catalog-header-bar">
            <div class="catalog-title-group">
                <h3>Certified Inventory Catalog</h3>
                <p>Browse authentic factory components, live depot quantities, and direct checkout.</p>
            </div>

            <!-- Filter tabs -->
            <div class="category-filter-nav">
                <button class="cat-filter-btn active" onclick="filterByTab(this, 'all')">All Products</button>
                <button class="cat-filter-btn" onclick="filterByTab(this, 'engine')">Engine &amp; Mechanical</button>
                <button class="cat-filter-btn" onclick="filterByTab(this, 'exteriors')">Exteriors &amp; Body</button>
                <button class="cat-filter-btn" onclick="filterByTab(this, 'interiors')">Interiors</button>
                <button class="cat-filter-btn" onclick="filterByTab(this, 'fasteners')">Nuts &amp; Fasteners</button>
            </div>

            <!-- Search box -->
            <div class="catalog-search-wrap">
                <i class="bi bi-search catalog-search-icon"></i>
                <input type="text" id="catalogSearchInput" class="catalog-search-input" placeholder="Search genuine vehicle parts..." oninput="handleCatalogSearch(this.value)">
            </div>
        </div>

        <!-- Dynamic Product Cards Grid -->
        <div class="products-showcase-grid" id="productsShowcaseGrid">
            <c:choose>
                <c:when test="${empty products}">
                    <div class="text-center py-5 col-12" style="grid-column: 1 / -1;">
                        <i class="bi bi-box-seam fs-1 text-muted d-block mb-3"></i>
                        <h5>No Spare Parts In Catalog</h5>
                        <p class="text-muted">The central warehouse inventory has not registered any items yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${products}">
                        <div class="product-item-card" data-part-name="${p.partName.toLowerCase()}">
                            <!-- Card Top Spec Row: Category Icon & Stock Status Pill -->
                            <div class="product-card-top-spec">
                                <div class="part-icon-box">
                                    <c:choose>
                                        <c:when test="${p.partName.toLowerCase().contains('wheel') || p.partName.toLowerCase().contains('rim')}">
                                            <img src="/images/icons/wheel_rim.png" alt="Wheel" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('tire') || p.partName.toLowerCase().contains('tyre')}">
                                            <img src="/images/icons/air_filter.png" alt="Tire" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('piston')}">
                                            <img src="/images/icons/piston_rod.png" alt="Piston" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('engine') || p.partName.toLowerCase().contains('motor') || p.partName.toLowerCase().contains('cylinder')}">
                                            <img src="/images/icons/engine_motor.png" alt="Engine" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('gear') || p.partName.toLowerCase().contains('transmission')}">
                                            <img src="/images/icons/engine_gears.png" alt="Transmission" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('belt') || p.partName.toLowerCase().contains('timing')}">
                                            <img src="/images/icons/timing_belt.png" alt="Timing Belt" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('turbo')}">
                                            <img src="/images/icons/turbocharger.png" alt="Turbo" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('alternator') || p.partName.toLowerCase().contains('generator')}">
                                            <img src="/images/icons/alternator.png" alt="Alternator" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('spark') || p.partName.toLowerCase().contains('plug') || p.partName.toLowerCase().contains('ignition')}">
                                            <img src="/images/icons/spark_plug.png" alt="Spark Plug" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('brake') || p.partName.toLowerCase().contains('pad') || p.partName.toLowerCase().contains('rotor') || p.partName.toLowerCase().contains('disc')}">
                                            <img src="/images/icons/brake_disc.png" alt="Brakes" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('handbrake')}">
                                            <img src="/images/icons/handbrake.png" alt="Handbrake" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('pedal')}">
                                            <img src="/images/icons/pedals.png" alt="Pedals" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('steer')}">
                                            <img src="/images/icons/steering_wheel.png" alt="Steering" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('shock') || p.partName.toLowerCase().contains('spring') || p.partName.toLowerCase().contains('strut') || p.partName.toLowerCase().contains('suspension')}">
                                            <img src="/images/icons/shock_absorber.png" alt="Suspension" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('axle')}">
                                            <img src="/images/icons/suspension_axle.png" alt="Axle" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('battery') || p.partName.toLowerCase().contains('electric')}">
                                            <img src="/images/icons/car_battery.png" alt="Battery" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('radiator') || p.partName.toLowerCase().contains('fan') || p.partName.toLowerCase().contains('cool')}">
                                            <img src="/images/icons/radiator_fan.png" alt="Radiator" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('exhaust') || p.partName.toLowerCase().contains('muffler') || p.partName.toLowerCase().contains('pipe')}">
                                            <img src="/images/icons/exhaust_muffler.png" alt="Exhaust" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('oil') && (p.partName.toLowerCase().contains('filter') || p.partName.toLowerCase().contains('air'))}">
                                            <img src="/images/icons/air_filter.png" alt="Filter" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('oil') || p.partName.toLowerCase().contains('lube') || p.partName.toLowerCase().contains('fluid')}">
                                            <img src="/images/icons/oil_canister.png" alt="Oil & Fluids" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('seat')}">
                                            <img src="/images/icons/car_seat.png" alt="Cabin Seat" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('door')}">
                                            <img src="/images/icons/car_door.png" alt="Door" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('bumper')}">
                                            <img src="/images/icons/bumper.png" alt="Bumper" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('chassis') || p.partName.toLowerCase().contains('body')}">
                                            <img src="/images/icons/car_body_chassis.png" alt="Chassis" class="part-vector-icon">
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('meter') || p.partName.toLowerCase().contains('gauge') || p.partName.toLowerCase().contains('speed')}">
                                            <img src="/images/icons/speedometer.png" alt="Telemetry" class="part-vector-icon">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/images/icons/car_jack.png" alt="Component" class="part-vector-icon">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Stock Status Tag -->
                                <c:choose>
                                    <c:when test="${p.quantity > 5}">
                                        <span class="stock-badge-tag tag-in-stock"><i class="bi bi-check2-circle"></i> In Stock (${p.quantity})</span>
                                    </c:when>
                                    <c:when test="${p.quantity > 0}">
                                        <span class="stock-badge-tag tag-low-stock"><i class="bi bi-exclamation-circle"></i> Low Stock (${p.quantity})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-badge-tag tag-out-stock"><i class="bi bi-dash-circle"></i> Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Middle: Category, Title & Customer Value Badges -->
                            <div>
                                <div class="part-category-tag">
                                    <c:choose>
                                        <c:when test="${p.partName.toLowerCase().contains('wheel') || p.partName.toLowerCase().contains('tire')}">
                                            <i class="bi bi-disc"></i> WHEELS &amp; TIRES
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('engine') || p.partName.toLowerCase().contains('motor')}">
                                            <i class="bi bi-gear-fill"></i> ENGINE &amp; POWERTRAIN
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('brake')}">
                                            <i class="bi bi-shield-fill-check"></i> BRAKING &amp; SAFETY
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('light') || p.partName.toLowerCase().contains('lamp')}">
                                            <i class="bi bi-lightbulb-fill"></i> LIGHTING &amp; ELECTRICAL
                                        </c:when>
                                        <c:when test="${p.partName.toLowerCase().contains('nut') || p.partName.toLowerCase().contains('bolt')}">
                                            <i class="bi bi-tools"></i> HARDWARE &amp; MOUNTING
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-award-fill"></i> VEHICLE REPLACEMENT PART
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <h4 class="product-name-title">${p.partName}</h4>
                                
                                <div class="product-meta-specs">
                                    <span class="meta-pill-tag">
                                        <i class="bi bi-patch-check-fill text-success"></i> 100% Genuine OEM
                                    </span>
                                    <span class="meta-pill-tag">
                                        <i class="bi bi-shield-check text-primary"></i> 1 Year Warranty
                                    </span>
                                    <span class="meta-pill-tag">
                                        <i class="bi bi-truck text-danger"></i> Express Dispatch
                                    </span>
                                </div>
                            </div>

                            <!-- Bottom Action & Price Row -->
                            <div class="product-card-footer">
                                <div class="product-price-val">
                                    <span class="product-price-label">Price per Unit</span>
                                    <span class="product-price-amount">
                                        Rs. <fmt:formatNumber value="${p.unitPrice}" pattern="#,##0.00"/>
                                    </span>
                                </div>
                                <div class="product-btn-group">
                                    <c:choose>
                                        <c:when test="${p.quantity > 0}">
                                            <button type="button" class="btn-card-add-cart" onclick="addToCart('${p.partId}', '${p.partName}', ${p.unitPrice}, ${p.quantity}, '${p.storageLocation}')" title="Add to Cart">
                                                <i class="bi bi-cart-plus"></i> Cart
                                            </button>
                                            <button type="button" class="btn-card-buy-now" onclick="openBuyModal('${p.partId}', '${p.partName}', ${p.unitPrice}, ${p.quantity})">
                                                Buy Now
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn-card-add-cart text-muted" disabled style="opacity:0.6;cursor:not-allowed;">
                                                Sold Out
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  8. FOOTER                                        -->
    <!-- ═════════════════════════════════════════════════ -->
    <footer class="site-footer">
        <div class="footer-content-wrap">
            <div>
                <div class="footer-brand-title">AUTO<span>PARTS</span></div>
                <p style="line-height:1.6;font-size:0.88rem;max-width:320px;">
                    Enterprise automotive vehicle spare parts management portal. Serving vehicle owners, repair workshops, and certified depot centers worldwide.
                </p>
            </div>
            <div class="footer-col">
                <h6>Quick Links</h6>
                <ul>
                    <li><a href="/customer">Home</a></li>
                    <li><a href="#catalogSection">All Parts Catalog</a></li>
                    <li><a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#myOrdersModal">Track Order</a></li>
                    <li><a href="javascript:void(0)" onclick="openAccountModal()">My Account</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h6>Popular Categories</h6>
                <ul>
                    <li><a href="javascript:void(0)" onclick="filterCatalogCategory('interiors')">Interiors &amp; Electronics</a></li>
                    <li><a href="javascript:void(0)" onclick="filterCatalogCategory('exteriors')">Exteriors &amp; Lights</a></li>
                    <li><a href="javascript:void(0)" onclick="filterCatalogCategory('engine')">Performance &amp; Engine</a></li>
                    <li><a href="javascript:void(0)" onclick="filterCatalogCategory('fasteners')">Fasteners &amp; Hardware</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h6>Contact Depot</h6>
                <ul>
                    <li><i class="bi bi-geo-alt me-1 text-danger"></i> Central Warehouse Depot, Colombo</li>
                    <li><i class="bi bi-telephone me-1 text-danger"></i> +94 11 234 5678</li>
                    <li><i class="bi bi-envelope me-1 text-danger"></i> support@parttrack.com</li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom-bar">
            <div>&copy; 2026 AutoParts by PartTrack. All rights reserved.</div>
            <div class="d-flex gap-3">
                <a href="javascript:void(0)" class="text-secondary text-decoration-none">Privacy Policy</a>
                <a href="javascript:void(0)" class="text-secondary text-decoration-none">Terms of Service</a>
                <a href="javascript:void(0)" class="text-secondary text-decoration-none">Warranty Standards</a>
            </div>
        </div>
    </footer>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL: DIRECT BUY NOW MODAL                      -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="buyProductModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background:var(--modal-bg);border:1px solid var(--card-border);border-radius:6px;">
                <div class="modal-header border-bottom" style="background:var(--topbar-bg);">
                    <h5 class="modal-title fw-bold" style="color:var(--txt-main);">
                        <i class="bi bi-bag-check-fill text-danger me-2"></i>Express Direct Order
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="/customer/buy" method="post">
                    <input type="hidden" name="partId" id="buyModalPartId">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Selected Product</label>
                            <input type="text" id="buyModalPartName" class="form-control fw-bold" readonly style="background:var(--input-bg);color:var(--txt-main);border-color:var(--card-border);">
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted">Unit Price</label>
                                <input type="text" id="buyModalUnitPrice" class="form-control" readonly style="background:var(--input-bg);color:var(--txt-main);border-color:var(--card-border);">
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted">Stock Level</label>
                                <input type="text" id="buyModalAvailableQty" class="form-control" readonly style="background:var(--input-bg);color:var(--txt-main);border-color:var(--card-border);">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold" style="color:var(--txt-main);">Order Quantity</label>
                            <input type="number" name="quantity" id="buyQuantityInput" class="form-control" value="1" min="1" oninput="updateBuyTotal()" required autofocus style="background:var(--card-bg);color:var(--txt-main);border-color:var(--card-border);">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Customer Name</label>
                            <input type="text" name="customerName" class="form-control" value="${not empty sessionScope.fullName ? sessionScope.fullName : (not empty sessionScope.currentUser ? sessionScope.currentUser : 'Customer')}" required style="background:var(--card-bg);color:var(--txt-main);border-color:var(--card-border);">
                        </div>
                        <div class="d-flex justify-content-between align-items-center p-3 rounded-2" style="background:var(--topbar-bg);border:1px solid var(--card-border);">
                            <span class="fw-bold" style="color:var(--txt-main);">Total Payable:</span>
                            <span class="fw-bold fs-5 text-danger font-monospace" id="buyModalTotalDisplay">Rs. 0.00</span>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-shop-now py-2 px-4 fs-6">Confirm Purchase</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  OFFCANVAS: SHOPPING CART SLIDE-OUT PANEL         -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="offcanvas offcanvas-end" tabindex="-1" id="cartOffcanvas" style="width:420px;background:var(--offcanvas-bg);border-left:1px solid var(--card-border);">
        <div class="offcanvas-header border-bottom" style="background:var(--topbar-bg);">
            <h5 class="offcanvas-title fw-bold" style="color:var(--txt-main);">
                <i class="bi bi-cart3 text-danger me-2"></i>Shopping Cart (<span id="cartHeaderQty">0</span>)
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
        </div>
        <div class="offcanvas-body p-3 d-flex flex-column" id="cartOffcanvasBody">
            <div id="cartItemsListContainer" class="flex-grow-1 overflow-auto pe-1">
                <!-- Dynamically rendered via JS -->
            </div>
            <div id="cartFooterArea" class="border-top pt-3 mt-auto">
                <!-- Subtotal and checkout button rendered dynamically -->
            </div>
        </div>
    </div>

    <!-- Hidden checkout form -->
    <form id="cartCheckoutForm" action="/customer/cart/checkout" method="post" style="display:none;">
        <input type="hidden" name="customerName" id="checkoutCustomerName">
        <input type="hidden" name="cartData" id="checkoutCartData">
    </form>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL: MY ORDERS & REAL-TIME TRACKING            -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="myOrdersModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
            <div class="modal-content" style="background:var(--modal-bg);border:1px solid var(--card-border);border-radius:6px;">
                <div class="modal-header border-bottom" style="background:var(--topbar-bg);">
                    <h5 class="modal-title fw-bold" style="color:var(--txt-main);">
                        <i class="bi bi-truck text-danger me-2"></i>My Orders &amp; Delivery Tracking
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom flex-wrap gap-2">
                        <div>
                            <span class="text-muted small">Customer Account:</span>
                            <span class="fw-bold ms-1" style="color:var(--txt-main);">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.fullName}">${sessionScope.fullName}</c:when>
                                    <c:when test="${not empty sessionScope.currentUser}">${sessionScope.currentUser}</c:when>
                                    <c:otherwise>Guest Customer</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="d-flex gap-2">
                            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-2 py-1">
                                <i class="bi bi-hourglass-split me-1"></i>${myProcessingCount} In Processing
                            </span>
                            <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-1">
                                <i class="bi bi-receipt me-1"></i>${myOrders.size()} Total Orders
                            </span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty myOrders}">
                            <div class="text-center py-5">
                                <i class="bi bi-bag-x fs-1 text-muted d-block mb-2"></i>
                                <h6 class="fw-bold" style="color:var(--txt-main);">No Orders Placed Yet</h6>
                                <p class="text-muted small">When you purchase parts through the catalog or cart, your order tracking and status will show here in real time.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="ord" items="${myOrders}">
                                    <div class="card p-3 border" style="background:var(--card-bg);border-radius:6px;border-color:var(--card-border) !important;">
                                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-2 pb-2 border-bottom">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="badge bg-secondary-subtle text-secondary border px-2 py-1 font-monospace fw-bold">#ORD-${ord.order_id}</span>
                                                <span class="text-muted small"><i class="bi bi-calendar3 me-1"></i>${ord.order_date}</span>
                                            </div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${ord.status == 'PROCESSING'}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 fw-bold" style="border-radius:99px;">
                                                            <i class="bi bi-gear-fill spinner-border spinner-border-sm me-1" style="width:.75rem;height:.75rem;"></i>PROCESSING (Order Being Prepared)
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${ord.status == 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-3 py-2 fw-bold" style="border-radius:99px;">
                                                            <i class="bi bi-hourglass-split me-1"></i>PROCESSING (Awaiting Sales Review)
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${ord.status == 'COMPLETED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-3 py-2 fw-bold" style="border-radius:99px;">
                                                            <i class="bi bi-check-circle-fill me-1"></i>DELIVERED / COMPLETED
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark border px-3 py-2 fw-bold">${ord.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <c:if test="${ord.status == 'PENDING'}">
                                            <div class="alert alert-warning py-2 px-3 mb-2 small d-flex align-items-center gap-2" style="border-radius:4px;background:rgba(245,158,11,0.08);border-color:rgba(245,158,11,0.3);">
                                                <i class="bi bi-hourglass-split text-warning fs-5"></i>
                                                <div>
                                                    <strong class="text-warning-emphasis">Your order is received and currently in processing.</strong>
                                                    <div style="color:var(--txt-main);">The Sales Manager is reviewing your order items for dispatch approval.</div>
                                                </div>
                                            </div>
                                        </c:if>

                                        <c:if test="${ord.status == 'PROCESSING'}">
                                            <div class="alert alert-primary py-2 px-3 mb-2 small d-flex align-items-center gap-2" style="border-radius:4px;">
                                                <i class="bi bi-truck text-primary fs-5"></i>
                                                <div>
                                                    <strong class="text-primary">The Sales Manager has reviewed and accepted your order.</strong>
                                                    <div style="color:var(--txt-main);">Warehouse logistics personnel are currently packaging your parts for delivery.</div>
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Order items -->
                                        <div class="table-responsive">
                                            <table class="table table-sm align-middle mb-0" style="font-size:0.86rem; color:var(--txt-main);">
                                                <thead>
                                                    <tr style="color:var(--txt-muted);">
                                                        <th>Part</th>
                                                        <th class="text-center">Qty</th>
                                                        <th class="text-end">Unit Price</th>
                                                        <th class="text-end">Subtotal</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="it" items="${myOrderItemsMap[ord.order_id]}">
                                                        <tr>
                                                            <td>
                                                                <span class="fw-bold">${it.part_name}</span>
                                                            </td>
                                                            <td class="text-center"><span class="badge bg-light text-dark border">${it.quantity}</span></td>
                                                            <td class="text-end font-monospace">Rs. <fmt:formatNumber value="${it.unit_price}" pattern="#,##0.00"/></td>
                                                            <td class="text-end font-monospace fw-bold" style="color:var(--brand-red);">Rs. <fmt:formatNumber value="${it.line_total}" pattern="#,##0.00"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center pt-2 mt-2 border-top">
                                            <span class="small text-muted">${ord.notes}</span>
                                            <div class="text-end">
                                                <span class="small text-muted me-2">Grand Total:</span>
                                                <span class="fw-bold font-monospace fs-6" style="color:var(--brand-red);">
                                                    Rs. <fmt:formatNumber value="${ord.total_amount}" pattern="#,##0.00"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL: CUSTOMER ACCOUNT PROFILE                  -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background:var(--modal-bg);border:1px solid var(--card-border);border-radius:6px;">
                <div class="modal-header border-bottom" style="background:var(--topbar-bg);">
                    <h5 class="modal-title fw-bold" style="color:var(--txt-main);">
                        <i class="bi bi-person-gear text-danger me-2"></i>Customer Account Settings
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="/customer/account/update" method="post">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Username</label>
                            <input type="text" class="form-control" value="${sessionScope.currentUser}" readonly style="background:var(--input-bg);color:var(--txt-main);border-color:var(--card-border);">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="${sessionScope.fullName}" required style="background:var(--card-bg);color:var(--txt-main);border-color:var(--card-border);">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Email Address</label>
                            <input type="email" name="email" class="form-control" value="${sessionScope.email}" required style="background:var(--card-bg);color:var(--txt-main);border-color:var(--card-border);">
                        </div>
                        <button type="submit" class="btn btn-shop-now py-2 w-100 fs-6 justify-content-center">Save Profile Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Notification Popup -->
    <div id="toastNotification" class="toast-notify">
        <i class="bi bi-cart-check-fill text-danger fs-5"></i>
        <span id="toastMessage">Item added to cart!</span>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-side script logic -->
    <script>
        // ============================================
        //  THEME TOGGLE
        // ============================================
        function toggleTheme() {
            var h = document.documentElement;
            var isDark = h.getAttribute('data-theme') === 'dark';
            var next = isDark ? 'light' : 'dark';
            h.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            updateThemeIcons(next);
        }

        function updateThemeIcons(theme) {
            var icon = document.getElementById('themeIcon');
            var txt = document.getElementById('themeText');
            if (icon) icon.className = (theme === 'dark') ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
            if (txt) txt.textContent = (theme === 'dark') ? 'Light' : 'Dark';
        }
        (function(){
            var cur = localStorage.getItem('theme') || 'light';
            updateThemeIcons(cur);
        })();

        // ============================================
        //  CART: STRICT CUSTOMER-SCOPED LOCALSTORAGE
        // ============================================
        var currentLoggedInUser = '${not empty sessionScope.currentUser ? sessionScope.currentUser : "guest"}';
        var CART_KEY = 'parttrack_cart_' + encodeURIComponent(currentLoggedInUser.toLowerCase().trim());

        // Purge legacy global key to avoid cross-customer pollution
        try {
            if (localStorage.getItem('parttrack_cart')) {
                localStorage.removeItem('parttrack_cart');
            }
        } catch(e) {}

        function getCart() {
            try { return JSON.parse(localStorage.getItem(CART_KEY)) || []; }
            catch(e) { return []; }
        }

        function saveCart(cart) {
            localStorage.setItem(CART_KEY, JSON.stringify(cart));
        }

        function addToCart(partId, partName, unitPrice, availableQty, location) {
            var cart = getCart();
            var existing = cart.find(function(i){ return i.partId === partId; });

            if (existing) {
                if (existing.quantity < availableQty) {
                    existing.quantity += 1;
                    showToast('Quantity increased for ' + partName);
                } else {
                    showToast('Maximum available stock reached (' + availableQty + ')');
                    return;
                }
            } else {
                cart.push({
                    partId: partId,
                    partName: partName,
                    unitPrice: unitPrice,
                    availableQty: availableQty,
                    quantity: 1,
                    location: location
                });
                showToast(partName + ' added to cart!');
            }

            saveCart(cart);
            updateCartUI();
        }

        function removeFromCart(partId) {
            var cart = getCart().filter(function(i){ return i.partId !== partId; });
            saveCart(cart);
            renderCartUI();
            updateCartUI();
        }

        function updateCartQty(partId, delta) {
            var cart = getCart();
            var item = cart.find(function(i){ return i.partId === partId; });
            if (!item) return;

            var newQty = item.quantity + delta;
            if (newQty < 1) {
                removeFromCart(partId);
                return;
            }
            if (newQty > item.availableQty) {
                showToast('Only ' + item.availableQty + ' units available in warehouse stock.');
                return;
            }
            item.quantity = newQty;
            saveCart(cart);
            renderCartUI();
            updateCartUI();
        }

        function updateCartUI() {
            var cart = getCart();
            var totalCount = cart.reduce(function(sum, i){ return sum + i.quantity; }, 0);
            var totalPrice = cart.reduce(function(sum, i){ return sum + (i.quantity * i.unitPrice); }, 0);

            // Update header count badge
            var hBadge = document.getElementById('headerCartCountBadge');
            if (hBadge) hBadge.textContent = totalCount;

            // Update floating cart widget
            var fCount = document.getElementById('floatCartCount');
            var fTotal = document.getElementById('floatCartTotal');
            if (fCount) fCount.textContent = totalCount;
            if (fTotal) fTotal.textContent = 'Rs. ' + totalPrice.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

            // Offcanvas header count
            var cHead = document.getElementById('cartHeaderQty');
            if (cHead) cHead.textContent = totalCount;
        }

        function renderCartUI() {
            var cart = getCart();
            var container = document.getElementById('cartItemsListContainer');
            var footerEl = document.getElementById('cartFooterArea');

            if (!container || !footerEl) return;

            if (cart.length === 0) {
                container.innerHTML = 
                    '<div class="text-center py-5">' +
                        '<i class="bi bi-cart-x fs-1 text-muted d-block mb-3"></i>' +
                        '<h6 class="fw-bold" style="color:var(--txt-main);">Your Cart is Empty</h6>' +
                        '<p class="text-muted small">Explore the popular categories or catalog to add parts.</p>' +
                    '</div>';
                footerEl.innerHTML = '';
                return;
            }

            var html = '<div class="d-flex flex-column gap-2">';
            var subtotal = 0;

            cart.forEach(function(item) {
                var lineTotal = item.unitPrice * item.quantity;
                subtotal += lineTotal;
                html += 
                    '<div class="p-3 rounded-2 border d-flex align-items-center justify-content-between gap-2" style="background:var(--topbar-bg);border-color:var(--card-border);">' +
                        '<div class="flex-grow-1 min-w-0">' +
                            '<div class="fw-bold text-truncate" style="color:var(--txt-main);font-size:0.92rem;">' + item.partName + '</div>' +
                            '<div class="font-monospace small text-muted">Rs. ' + item.unitPrice.toLocaleString('en-US', {minimumFractionDigits:2}) + ' &times; ' + item.quantity + '</div>' +
                            '<div class="fw-bold font-monospace" style="color:var(--brand-red);font-size:0.92rem;">Rs. ' + lineTotal.toLocaleString('en-US', {minimumFractionDigits:2}) + '</div>' +
                        '</div>' +
                        '<div class="d-flex align-items-center gap-1">' +
                            '<button class="btn btn-sm btn-outline-secondary px-2 py-0" onclick="updateCartQty(\'' + item.partId + '\', -1)">-</button>' +
                            '<span class="fw-bold px-1 small" style="color:var(--txt-main);">' + item.quantity + '</span>' +
                            '<button class="btn btn-sm btn-outline-secondary px-2 py-0" onclick="updateCartQty(\'' + item.partId + '\', 1)">+</button>' +
                            '<button class="btn btn-sm btn-link text-danger ms-1" onclick="removeFromCart(\'' + item.partId + '\')" title="Remove"><i class="bi bi-trash"></i></button>' +
                        '</div>' +
                    '</div>';
            });
            html += '</div>';
            container.innerHTML = html;

            var sessionName = '${not empty sessionScope.fullName ? sessionScope.fullName : (not empty sessionScope.currentUser ? sessionScope.currentUser : "Customer")}';

            footerEl.innerHTML = 
                '<div class="d-flex justify-content-between align-items-center mb-3">' +
                    '<span class="fw-bold" style="color:var(--txt-muted);">Cart Subtotal:</span>' +
                    '<span class="fs-5 fw-bold font-monospace" style="color:var(--brand-red);">Rs. ' + subtotal.toLocaleString('en-US', {minimumFractionDigits:2}) + '</span>' +
                '</div>' +
                '<div class="mb-3">' +
                    '<label class="form-label small fw-bold text-muted mb-1">Customer Name for Dispatch</label>' +
                    '<input type="text" id="cartCustomerNameInput" class="form-control form-control-sm" value="' + sessionName + '" style="background:var(--card-bg);color:var(--txt-main);border-color:var(--card-border);">' +
                '</div>' +
                '<button class="btn btn-shop-now w-100 py-2 justify-content-center" onclick="proceedToCheckout()">' +
                    '<i class="bi bi-shield-lock-fill me-1"></i> Confirm &amp; Place Order' +
                '</button>';
        }

        function toggleCartOffcanvas() {
            var el = document.getElementById('cartOffcanvas');
            var instance = bootstrap.Offcanvas.getOrCreateInstance(el);
            renderCartUI();
            instance.toggle();
        }

        function proceedToCheckout() {
            var cart = getCart();
            if (cart.length === 0) {
                showToast('Your cart is empty.');
                return;
            }
            var custName = document.getElementById('cartCustomerNameInput').value.trim() || 'Customer';
            var cartJson = JSON.stringify(cart.map(function(i){
                return { partId: i.partId, partName: i.partName, quantity: i.quantity, unitPrice: i.unitPrice };
            }));

            document.getElementById('checkoutCustomerName').value = custName;
            document.getElementById('checkoutCartData').value = cartJson;

            // Clear local cart storage
            saveCart([]);
            updateCartUI();

            document.getElementById('cartCheckoutForm').submit();
        }

        // ============================================
        //  DIRECT BUY MODAL
        // ============================================
        var currentUnitPrice = 0;
        function openBuyModal(partId, partName, unitPrice, availableQty) {
            currentUnitPrice = unitPrice;
            document.getElementById('buyModalPartId').value = partId;
            document.getElementById('buyModalPartName').value = partName;
            document.getElementById('buyModalUnitPrice').value = 'Rs. ' + unitPrice.toLocaleString('en-US', {minimumFractionDigits:2});
            document.getElementById('buyModalAvailableQty').value = availableQty + ' Units Available';
            
            var q = document.getElementById('buyQuantityInput');
            q.value = 1;
            q.max = availableQty;
            updateBuyTotal();

            var modal = new bootstrap.Modal(document.getElementById('buyProductModal'));
            modal.show();
        }

        function updateBuyTotal() {
            var q = parseInt(document.getElementById('buyQuantityInput').value) || 0;
            var tot = q * currentUnitPrice;
            document.getElementById('buyModalTotalDisplay').textContent = 'Rs. ' + tot.toLocaleString('en-US', {minimumFractionDigits:2});
        }

        function openAccountModal() {
            var modal = new bootstrap.Modal(document.getElementById('accountModal'));
            modal.show();
        }

        function focusCatalogSearch() {
            var el = document.getElementById('catalogSearchInput');
            if (el) {
                el.focus();
                el.scrollIntoView({ behavior: 'smooth' });
            }
        }

        // ============================================
        //  SEARCH & CATEGORY FILTERING
        // ============================================
        function handleCatalogSearch(val) {
            var query = val.toLowerCase().trim();
            var cards = document.querySelectorAll('.product-item-card');
            cards.forEach(function(card) {
                var name = card.getAttribute('data-part-name') || '';
                if (name.includes(query)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function searchCatalogFor(term) {
            var s = document.getElementById('catalogSearchInput');
            if (s) {
                s.value = term;
                handleCatalogSearch(term);
                s.scrollIntoView({ behavior: 'smooth' });
            }
        }

        function filterCatalogCategory(categoryKey) {
            var s = document.getElementById('catalogSearchInput');
            if (categoryKey === 'interiors') {
                searchCatalogFor('');
            } else if (categoryKey === 'exteriors') {
                searchCatalogFor('wheel');
            } else if (categoryKey === 'engine') {
                searchCatalogFor('engine');
            } else if (categoryKey === 'fasteners') {
                searchCatalogFor('nut');
            }
            document.getElementById('catalogSection').scrollIntoView({ behavior: 'smooth' });
        }

        function filterByTab(btn, tabKey) {
            document.querySelectorAll('.cat-filter-btn').forEach(function(b){ b.classList.remove('active'); });
            btn.classList.add('active');

            if (tabKey === 'all') {
                searchCatalogFor('');
            } else if (tabKey === 'engine') {
                searchCatalogFor('engine');
            } else if (tabKey === 'exteriors') {
                searchCatalogFor('wheel');
            } else if (tabKey === 'interiors') {
                searchCatalogFor('peanut');
            } else if (tabKey === 'fasteners') {
                searchCatalogFor('nut');
            }
        }

        function showToast(msg) {
            var t = document.getElementById('toastNotification');
            var m = document.getElementById('toastMessage');
            if (t && m) {
                m.textContent = msg;
                t.style.display = 'flex';
                setTimeout(function() {
                    t.style.display = 'none';
                }, 3000);
            }
        }

        // ============================================
        //  HERO CAROUSEL LOGIC (4 AUTOMOTIVE SLIDES)
        // ============================================
        var currentHeroIndex = 0;
        var totalHeroSlides = 4;
        var heroAutoPlayTimer = null;

        function showHeroSlide(index) {
            currentHeroIndex = (index + totalHeroSlides) % totalHeroSlides;
            for (var i = 0; i < totalHeroSlides; i++) {
                var slide = document.getElementById('heroSlide' + (i + 1));
                var dot = document.getElementById('heroDot' + i);
                if (slide) {
                    if (i === currentHeroIndex) {
                        slide.style.display = 'flex';
                        slide.style.opacity = '0';
                        slide.style.transition = 'opacity 0.6s ease';
                        setTimeout(function(s){ if(s) s.style.opacity = '1'; }, 20, slide);
                    } else {
                        slide.style.display = 'none';
                    }
                }
                if (dot) {
                    if (i === currentHeroIndex) dot.classList.add('active');
                    else dot.classList.remove('active');
                }
            }
        }

        function nextHeroSlide() {
            resetHeroTimer();
            showHeroSlide(currentHeroIndex + 1);
        }

        function prevHeroSlide() {
            resetHeroTimer();
            showHeroSlide(currentHeroIndex - 1);
        }

        function goToHeroSlide(index) {
            resetHeroTimer();
            showHeroSlide(index);
        }

        function resetHeroTimer() {
            if (heroAutoPlayTimer) clearInterval(heroAutoPlayTimer);
            heroAutoPlayTimer = setInterval(function() {
                showHeroSlide(currentHeroIndex + 1);
            }, 5000); // Automatically rotates every 5 seconds
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateCartUI();
            resetHeroTimer();

            // Clear cart if server signaled
            <c:if test="${cartCleared == true}">
                try { localStorage.removeItem(CART_KEY); } catch(e){}
                updateCartUI();
            </c:if>
        });
    </script>
</body>
</html>
