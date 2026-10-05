package com.sparepartmanagementsystem.core;

import com.sparepartmanagementsystem.inventory.InventoryReport;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;

@Service
public class PdfReportService {

    private static final BaseColor NAVY_PRIMARY = new BaseColor(30, 58, 138);
    private static final BaseColor NAVY_DARK = new BaseColor(15, 23, 42);
    private static final BaseColor SLATE_HEADER = new BaseColor(30, 41, 59);
    private static final BaseColor LIGHT_BG = new BaseColor(248, 250, 252);
    private static final BaseColor ALT_ROW_BG = new BaseColor(241, 245, 249);
    private static final BaseColor BORDER_COLOR = new BaseColor(226, 232, 240);
    private static final BaseColor TEXT_MUTED = new BaseColor(100, 116, 139);

    /**
     * Generates a professional, topic-wise structured PDF from an InventoryReport entity.
     */
    public byte[] generateInventoryReportPdf(InventoryReport report) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document document = new Document(PageSize.A4, 36, 36, 36, 36);
            PdfWriter.getInstance(document, baos);
            document.open();

            // 1. Header Banner (Brand, Official Document Type, Metadata)
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.setWidthPercentage(100);
            headerTable.setWidths(new float[]{65f, 35f});

            Font brandFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 17, NAVY_PRIMARY);
            Font subBrandFont = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, TEXT_MUTED);
            Paragraph brandPara = new Paragraph();
            brandPara.add(new Chunk("PARTTRACK AUTOMOTIVE DEPOT\n", brandFont));
            brandPara.add(new Chunk("Central Warehouse Logistics & Spare Part Depot System", subBrandFont));
            
            PdfPCell leftCell = new PdfPCell(brandPara);
            leftCell.setBorder(Rectangle.NO_BORDER);
            leftCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            headerTable.addCell(leftCell);

            Font docTypeFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, NAVY_DARK);
            Font docDateFont = FontFactory.getFont(FontFactory.HELVETICA, 8f, TEXT_MUTED);
            Paragraph docTypePara = new Paragraph();
            docTypePara.setAlignment(Element.ALIGN_RIGHT);
            docTypePara.add(new Chunk("OFFICIAL AUDIT REPORT\n", docTypeFont));
            String dateStr = report.getGeneratedDate() != null ? report.getGeneratedDate() : new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            docTypePara.add(new Chunk("Generated: " + dateStr + "\nAudit Ref: #" + (report.getReportId() != null ? report.getReportId() : "N/A"), docDateFont));
            
            PdfPCell rightCell = new PdfPCell(docTypePara);
            rightCell.setBorder(Rectangle.NO_BORDER);
            rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            rightCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            headerTable.addCell(rightCell);

            document.add(headerTable);

            // Divider Line
            LineSeparator ls = new LineSeparator();
            ls.setLineColor(NAVY_PRIMARY);
            ls.setLineWidth(1.5f);
            document.add(new Paragraph("\n"));
            document.add(ls);
            document.add(new Paragraph(" "));

            // 2. Metadata Summary Card (4 columns)
            PdfPTable metaTable = new PdfPTable(4);
            metaTable.setWidthPercentage(100);
            metaTable.setWidths(new float[]{22f, 28f, 22f, 28f});

            addMetaCell(metaTable, "Report Title:", true);
            addMetaCell(metaTable, report.getReportTitle() != null ? report.getReportTitle() : "Official Warehouse Report", false);

            addMetaCell(metaTable, "Category:", true);
            addMetaCell(metaTable, report.getReportType() != null ? report.getReportType() : "Inventory Valuation", false);

            addMetaCell(metaTable, "Dispatched By:", true);
            addMetaCell(metaTable, report.getGeneratedBy() != null ? report.getGeneratedBy() : "Inventory Admin", false);

            addMetaCell(metaTable, "Admin Status:", true);
            addMetaCell(metaTable, report.getStatus() != null ? report.getStatus() : "Pending Admin Review", false);

            addMetaCell(metaTable, "Date Range:", true);
            addMetaCell(metaTable, (report.getFromDate() != null ? report.getFromDate() : "All") + " to " + (report.getToDate() != null ? report.getToDate() : "Current"), false);

            addMetaCell(metaTable, "Manager Notes:", true);
            addMetaCell(metaTable, (report.getNotes() != null && !report.getNotes().isBlank()) ? report.getNotes() : "Standard operational audit", false);

            document.add(metaTable);
            document.add(new Paragraph(" "));

            // 3. TOPIC-WISE CONTENT GENERATION
            String content = report.getReportContent() != null ? report.getReportContent() : "";
            parseAndRenderTopics(document, content);

            // 4. Footer & Signature Certification Block
            document.add(new Paragraph("\n"));
            PdfPTable footerTable = new PdfPTable(2);
            footerTable.setWidthPercentage(100);
            footerTable.setWidths(new float[]{60f, 40f});

            Font footerLegalFont = FontFactory.getFont(FontFactory.HELVETICA, 7.5f, TEXT_MUTED);
            Paragraph legalPara = new Paragraph("This document is an electronically certified official record generated from PartTrack Depot.\nConfidential — Authorized Administrative & Audit Personnel Only.", footerLegalFont);
            PdfPCell legalCell = new PdfPCell(legalPara);
            legalCell.setBorder(Rectangle.NO_BORDER);
            footerTable.addCell(legalCell);

            Font sigFont = FontFactory.getFont(FontFactory.HELVETICA, 8f, SLATE_HEADER);
            Paragraph sigPara = new Paragraph("Audit Certified by: _____________________\nExecutive Stamp & Seal", sigFont);
            sigPara.setAlignment(Element.ALIGN_RIGHT);
            PdfPCell sigCell = new PdfPCell(sigPara);
            sigCell.setBorder(Rectangle.NO_BORDER);
            sigCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            footerTable.addCell(sigCell);

            document.add(footerTable);

            document.close();
            return baos.toByteArray();
        } catch (Exception e) {
            String fallback = "Report Title: " + report.getReportTitle() + "\n\n" + report.getReportContent();
            return fallback.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        }
    }

    /**
     * Generates a PDF directly from ad-hoc title and raw content.
     */
    public byte[] generateRawContentPdf(String title, String category, String notes, String content) {
        InventoryReport dummy = new InventoryReport();
        dummy.setReportTitle(title);
        dummy.setReportType(category != null ? category : "Warehouse Inventory Valuation");
        dummy.setGeneratedBy("Inventory Admin / Report Manager");
        dummy.setGeneratedDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        dummy.setStatus("Generated & Verified");
        dummy.setNotes(notes);
        dummy.setReportContent(content);
        return generateInventoryReportPdf(dummy);
    }

    /* --------------------------------------------------------------------------
     *  TOPIC-WISE PARSING & RENDERING ENGINE
     * -------------------------------------------------------------------------- */
    private void parseAndRenderTopics(Document document, String content) throws DocumentException {
        if (content == null || content.isBlank()) {
            renderCalloutBox(document, "No detailed report content recorded for this filing.", false);
            return;
        }

        String[] rawLines = content.split("\\r?\\n");
        List<String> cleanLines = new ArrayList<>();

        for (String l : rawLines) {
            if (l == null) continue;
            String t = l.trim();
            // Skip dividers
            if (t.matches("^[\\-=_\\s]{3,}$") || t.contains("-----------") || t.contains("===========")) continue;
            // Skip redundant company headers
            if (t.startsWith("PARTTRACK AUTOMOTIVE DEPOT")) continue;
            // Skip leading redundant metadata lines (already displayed in top metadata card)
            if (t.startsWith("Report Title:") || t.startsWith("Category:") || t.startsWith("Audit Timeframe:") ||
                t.startsWith("Submitted By:") || t.startsWith("Submission Date:") || t.startsWith("Report Type:") ||
                t.startsWith("Generated Date:") || t.startsWith("Period Range:") || t.startsWith("Generated By:") ||
                t.startsWith("Manager Notes:")) {
                continue;
            }
            cleanLines.add(t);
        }

        // Group into Topics
        class TopicBlock {
            String title;
            List<String> items = new ArrayList<>();
            TopicBlock(String t) { this.title = t; }
        }

        List<TopicBlock> topics = new ArrayList<>();
        TopicBlock current = null;

        for (String line : cleanLines) {
            if (line.isEmpty()) continue;

            boolean isTopicHeader = isHeaderLine(line);
            if (isTopicHeader) {
                String cleanTitle = line.endsWith(":") ? line.substring(0, line.length() - 1).trim() : line.trim();
                current = new TopicBlock(cleanTitle);
                topics.add(current);
            } else {
                if (current == null) {
                    current = new TopicBlock("EXECUTIVE AUDIT SUMMARY");
                    topics.add(current);
                }
                current.items.add(line);
            }
        }

        if (topics.isEmpty()) {
            renderCalloutBox(document, "Audit details logged successfully without itemized breakdown.", false);
            return;
        }

        // Render each topic as a distinct structured section
        int topicIndex = 1;
        for (TopicBlock tb : topics) {
            addTopicRibbon(document, topicIndex++, tb.title);
            renderTopicBody(document, tb.title, tb.items);
            document.add(new Paragraph(" "));
        }
    }

    private boolean isHeaderLine(String line) {
        if (line.startsWith("•") || line.startsWith("*") || line.startsWith("-")) return false;
        if (line.contains(" | Customer:") || line.contains(" | Date:") || line.contains(" — ")) return false;
        
        String u = line.toUpperCase();
        if (u.contains("COMMERCIAL FINANCIAL SUMMARY") ||
            u.contains("ACTIVE PROCESSING CUSTOMER ORDERS") ||
            u.contains("RECENT COMPLETED CUSTOMER SALES") ||
            u.contains("TOP DEMAND SPARE PARTS") ||
            u.contains("SALES MANAGER AUDIT REMARKS") ||
            u.contains("EXECUTIVE SUMMARY METRICS") ||
            u.contains("CRITICAL LOW STOCK") ||
            u.contains("CURRENT WAREHOUSE REPOSITORY") ||
            u.contains("AUDIT SUMMARY")) {
            return true;
        }
        
        return line.matches("^[0-9]+[\\.\\)]\\s+[A-Z0-9\\s&/\\-]+$") ||
               (line.matches("^[A-Z0-9\\s&()\\-/]{4,}:?$") && line.length() < 60);
    }

    private void addTopicRibbon(Document document, int index, String title) throws DocumentException {
        PdfPTable ribbon = new PdfPTable(1);
        ribbon.setWidthPercentage(100);

        Font ribbonFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9.5f, BaseColor.WHITE);
        String formattedTitle = String.format("%d.  %s", index, title.toUpperCase());
        PdfPCell cell = new PdfPCell(new Phrase(formattedTitle, ribbonFont));
        cell.setBackgroundColor(NAVY_PRIMARY);
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPaddingTop(5f);
        cell.setPaddingBottom(5f);
        cell.setPaddingLeft(8f);
        cell.setPaddingRight(8f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        ribbon.addCell(cell);

        document.add(ribbon);
    }

    private void renderTopicBody(Document document, String title, List<String> items) throws DocumentException {
        if (items.isEmpty()) {
            renderCalloutBox(document, "No active records logged under this topic.", false);
            return;
        }

        String first = items.get(0).trim();

        // 1. Single text remark or "No active orders..."
        if (items.size() == 1 && (!first.startsWith("•") && !first.startsWith("*") && !first.startsWith("-"))) {
            renderCalloutBox(document, first, title.toUpperCase().contains("REMARKS") || title.toUpperCase().contains("SUMMARY"));
            return;
        }

        // 2. Orders list
        boolean isOrders = false;
        for (String it : items) {
            if (it.contains("Order #") || it.contains("Customer:")) {
                isOrders = true;
                break;
            }
        }
        if (isOrders) {
            renderOrdersTable(document, items);
            return;
        }

        // 3. Parts sales list
        boolean isPartsSales = false;
        for (String it : items) {
            if (it.contains("units sold — Rs.")) {
                isPartsSales = true;
                break;
            }
        }
        if (isPartsSales) {
            renderPartsTable(document, items);
            return;
        }

        // 4. Warehouse repository catalog list
        boolean isWarehouseCatalog = false;
        for (String it : items) {
            if (it.contains("Valuation: Rs.") && it.contains("units")) {
                isWarehouseCatalog = true;
                break;
            }
        }
        if (isWarehouseCatalog) {
            renderWarehouseCatalogTable(document, items);
            return;
        }

        // 5. Critical low stock audit list
        boolean isLowStockList = false;
        for (String it : items) {
            if (it.contains("Reorder:") || it.contains("OUT OF STOCK") || it.contains("LOW STOCK")) {
                isLowStockList = true;
                break;
            }
        }
        if (isLowStockList) {
            renderLowStockTable(document, items);
            return;
        }

        // 6. Key: Value metrics table
        boolean hasColons = false;
        for (String it : items) {
            if (it.contains(":")) {
                hasColons = true;
                break;
            }
        }
        if (hasColons) {
            renderMetricsTable(document, items);
            return;
        }

        // 7. General fallback: clean formatted bullets
        renderGeneralBullets(document, items);
    }

    private void renderMetricsTable(Document document, List<String> items) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{55f, 45f});

        Font keyFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.5f, SLATE_HEADER);
        Font valFont = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, NAVY_DARK);

        boolean alt = false;
        for (String item : items) {
            String clean = item.replaceFirst("^[•\\*\\-]\\s*", "").trim();
            int colonIdx = clean.indexOf(":");
            String key = colonIdx > 0 ? clean.substring(0, colonIdx).trim() : clean;
            String val = colonIdx > 0 ? clean.substring(colonIdx + 1).trim() : "";

            PdfPCell keyCell = new PdfPCell(new Phrase(key, keyFont));
            keyCell.setBackgroundColor(alt ? ALT_ROW_BG : LIGHT_BG);
            keyCell.setBorderColor(BORDER_COLOR);
            keyCell.setPadding(5.5f);
            keyCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(keyCell);

            PdfPCell valCell = new PdfPCell(new Phrase(val, valFont));
            valCell.setBackgroundColor(alt ? ALT_ROW_BG : BaseColor.WHITE);
            valCell.setBorderColor(BORDER_COLOR);
            valCell.setPadding(5.5f);
            valCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(valCell);

            alt = !alt;
        }

        document.add(table);
    }

    private void renderOrdersTable(Document document, List<String> items) throws DocumentException {
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{18f, 32f, 28f, 22f});

        addTableHeaderCell(table, "Order Ref");
        addTableHeaderCell(table, "Customer Name");
        addTableHeaderCell(table, "Order Date & Time");
        addTableHeaderCell(table, "Total Amount");

        Font rowFont = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, NAVY_DARK);
        Font boldRowFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.5f, NAVY_PRIMARY);

        boolean alt = false;
        for (String item : items) {
            String clean = item.replaceFirst("^[•\\*\\-]\\s*", "").trim();
            if (clean.startsWith("No ")) {
                PdfPCell emptyCell = new PdfPCell(new Phrase(clean, rowFont));
                emptyCell.setColspan(4);
                emptyCell.setPadding(6f);
                emptyCell.setBackgroundColor(BaseColor.WHITE);
                emptyCell.setBorderColor(BORDER_COLOR);
                table.addCell(emptyCell);
                continue;
            }

            // Sample line: Order #1 | Customer: poorna | Date: 2026-10-01 16:30:54 | Rs. 7,256.25
            String orderRef = "";
            String customer = "";
            String date = "";
            String amount = "";

            String[] parts = clean.split("\\|");
            for (String p : parts) {
                String pt = p.trim();
                if (pt.startsWith("Order #")) {
                    orderRef = pt;
                } else if (pt.startsWith("Customer:")) {
                    customer = pt.substring(9).trim();
                } else if (pt.startsWith("Date:")) {
                    date = pt.substring(5).trim();
                } else if (pt.startsWith("Rs.") || pt.matches(".*[0-9]+.*")) {
                    amount = pt;
                }
            }
            if (orderRef.isEmpty() && parts.length > 0) orderRef = parts[0].trim();

            BaseColor bg = alt ? ALT_ROW_BG : BaseColor.WHITE;
            addTableCell(table, orderRef, boldRowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, customer, rowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, date, rowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, amount, boldRowFont, bg, Element.ALIGN_RIGHT);
            alt = !alt;
        }

        document.add(table);
    }

    private void renderPartsTable(Document document, List<String> items) throws DocumentException {
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{38f, 18f, 20f, 24f});

        addTableHeaderCell(table, "Part Name");
        addTableHeaderCell(table, "SKU Ref");
        addTableHeaderCell(table, "Units Sold");
        addTableHeaderCell(table, "Sales Revenue");

        Font rowFont = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, NAVY_DARK);
        Font boldRowFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.5f, NAVY_PRIMARY);

        boolean alt = false;
        for (String item : items) {
            String clean = item.replaceFirst("^[•\\*\\-]\\s*", "").trim();
            if (clean.startsWith("No ")) {
                PdfPCell emptyCell = new PdfPCell(new Phrase(clean, rowFont));
                emptyCell.setColspan(4);
                emptyCell.setPadding(6f);
                emptyCell.setBackgroundColor(BaseColor.WHITE);
                emptyCell.setBorderColor(BORDER_COLOR);
                table.addCell(emptyCell);
                continue;
            }

            // Sample line: peanut [004] — 1 units sold — Rs. 6,250.00
            String partName = "";
            String sku = "";
            String qty = "";
            String revenue = "";

            int skuStart = clean.indexOf("[");
            int skuEnd = clean.indexOf("]");
            if (skuStart > 0 && skuEnd > skuStart) {
                partName = clean.substring(0, skuStart).trim();
                sku = clean.substring(skuStart + 1, skuEnd).trim();
            }

            String[] chunks = clean.split("[—\\-]");
            if (chunks.length >= 3) {
                qty = chunks[1].trim();
                revenue = chunks[2].trim();
            } else if (chunks.length == 2) {
                revenue = chunks[1].trim();
            }

            if (partName.isEmpty()) partName = clean;

            BaseColor bg = alt ? ALT_ROW_BG : BaseColor.WHITE;
            addTableCell(table, partName, boldRowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, sku, rowFont, bg, Element.ALIGN_CENTER);
            addTableCell(table, qty, rowFont, bg, Element.ALIGN_CENTER);
            addTableCell(table, revenue, boldRowFont, bg, Element.ALIGN_RIGHT);
            alt = !alt;
        }

        document.add(table);
    }

    private void renderWarehouseCatalogTable(Document document, List<String> items) throws DocumentException {
        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{28f, 12f, 18f, 12f, 14f, 16f});

        addTableHeaderCell(table, "Part Name");
        addTableHeaderCell(table, "SKU");
        addTableHeaderCell(table, "Location");
        addTableHeaderCell(table, "Qty");
        addTableHeaderCell(table, "Unit Price");
        addTableHeaderCell(table, "Total Value");

        Font rowFont = FontFactory.getFont(FontFactory.HELVETICA, 8.2f, NAVY_DARK);
        Font boldRowFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.2f, NAVY_PRIMARY);

        boolean alt = false;
        for (String item : items) {
            String clean = item.replaceFirst("^[•\\*\\-]\\s*", "").trim();
            String[] segments = clean.split("[—\\-]");
            String name = segments.length > 0 ? segments[0].trim() : clean;
            String sku = "";
            int bStart = name.indexOf("[");
            int bEnd = name.indexOf("]");
            if (bStart > 0 && bEnd > bStart) {
                sku = name.substring(bStart + 1, bEnd).trim();
                name = name.substring(0, bStart).trim();
            }
            String loc = segments.length > 1 ? segments[1].trim() : "Main Shelf";
            String qty = segments.length > 2 ? segments[2].trim() : "0";
            String unitPrice = segments.length > 3 ? segments[3].trim() : "-";
            String valuation = segments.length > 4 ? segments[4].replace("(", "").replace(")", "").replace("Valuation:", "").trim() : "-";

            BaseColor bg = alt ? ALT_ROW_BG : BaseColor.WHITE;
            addTableCell(table, name, boldRowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, sku, rowFont, bg, Element.ALIGN_CENTER);
            addTableCell(table, loc, rowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, qty, rowFont, bg, Element.ALIGN_CENTER);
            addTableCell(table, unitPrice, rowFont, bg, Element.ALIGN_RIGHT);
            addTableCell(table, valuation, boldRowFont, bg, Element.ALIGN_RIGHT);
            alt = !alt;
        }

        document.add(table);
    }

    private void renderLowStockTable(Document document, List<String> items) throws DocumentException {
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{32f, 15f, 18f, 18f, 17f});

        addTableHeaderCell(table, "Part Name");
        addTableHeaderCell(table, "SKU");
        addTableHeaderCell(table, "Stock Level");
        addTableHeaderCell(table, "Unit Price");
        addTableHeaderCell(table, "Status");

        Font rowFont = FontFactory.getFont(FontFactory.HELVETICA, 8.2f, NAVY_DARK);
        Font boldRowFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.2f, NAVY_PRIMARY);
        Font alertFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.2f, new BaseColor(220, 38, 38));

        boolean alt = false;
        for (String item : items) {
            String clean = item.replaceFirst("^[•\\*\\-]\\s*", "").trim();
            String[] segments = clean.split("[—\\-]");
            String name = segments.length > 0 ? segments[0].trim() : clean;
            String sku = "";
            int bStart = name.indexOf("[");
            int bEnd = name.indexOf("]");
            if (bStart > 0 && bEnd > bStart) {
                sku = name.substring(bStart + 1, bEnd).trim();
                name = name.substring(0, bStart).trim();
            }
            String stock = segments.length > 1 ? segments[1].trim() : "-";
            String price = segments.length > 2 ? segments[2].trim() : "-";
            String status = segments.length > 3 ? segments[3].trim() : "LOW STOCK";

            BaseColor bg = alt ? ALT_ROW_BG : BaseColor.WHITE;
            addTableCell(table, name, boldRowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, sku, rowFont, bg, Element.ALIGN_CENTER);
            addTableCell(table, stock, rowFont, bg, Element.ALIGN_LEFT);
            addTableCell(table, price, rowFont, bg, Element.ALIGN_RIGHT);
            addTableCell(table, status, alertFont, bg, Element.ALIGN_CENTER);
            alt = !alt;
        }

        document.add(table);
    }

    private void renderCalloutBox(Document document, String text, boolean isNote) throws DocumentException {
        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);

        Font textFont = isNote
                ? FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8.8f, SLATE_HEADER)
                : FontFactory.getFont(FontFactory.HELVETICA, 8.5f, TEXT_MUTED);

        PdfPCell cell = new PdfPCell(new Phrase(text, textFont));
        cell.setBackgroundColor(LIGHT_BG);
        cell.setBorderColor(BORDER_COLOR);
        cell.setBorderWidthLeft(3.5f);
        cell.setBorderColorLeft(NAVY_PRIMARY);
        cell.setPadding(8f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        document.add(table);
    }

    private void renderGeneralBullets(Document document, List<String> items) throws DocumentException {
        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);

        Font font = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, NAVY_DARK);
        for (String item : items) {
            String clean = item.replaceFirst("^[•\\*\\-]\\s*", "").trim();
            PdfPCell cell = new PdfPCell(new Phrase("•  " + clean, font));
            cell.setBackgroundColor(BaseColor.WHITE);
            cell.setBorderColor(BORDER_COLOR);
            cell.setPadding(5f);
            table.addCell(cell);
        }

        document.add(table);
    }

    private void addTableHeaderCell(PdfPTable table, String title) {
        Font font = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.2f, SLATE_HEADER);
        PdfPCell cell = new PdfPCell(new Phrase(title, font));
        cell.setBackgroundColor(ALT_ROW_BG);
        cell.setBorderColor(BORDER_COLOR);
        cell.setPadding(5.5f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }

    private void addTableCell(PdfPTable table, String text, Font font, BaseColor bg, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "", font));
        cell.setBackgroundColor(bg);
        cell.setBorderColor(BORDER_COLOR);
        cell.setPadding(5f);
        cell.setHorizontalAlignment(align);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }

    private void addMetaCell(PdfPTable table, String text, boolean isLabel) {
        Font font = isLabel 
                ? FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8.5f, NAVY_PRIMARY)
                : FontFactory.getFont(FontFactory.HELVETICA, 8.5f, SLATE_HEADER);
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(isLabel ? LIGHT_BG : BaseColor.WHITE);
        cell.setBorderColor(BORDER_COLOR);
        cell.setPadding(6);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }
}
