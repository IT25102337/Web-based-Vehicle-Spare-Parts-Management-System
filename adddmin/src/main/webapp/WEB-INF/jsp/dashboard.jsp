<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports &amp; Business Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .dashboard-grid { display: flex; gap: 20px; margin-bottom: 30px; }
        .card { border: 1px solid #ccc; padding: 15px; border-radius: 5px; background: #FCE5CD; }
        .section { margin-bottom: 40px; border-top: 2px solid #D6B656; padding-top: 15px; }
        button { background-color: #006699; color: white; border: none; padding: 10px; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .alert { color: #CC0000; font-weight: bold; margin-bottom: 15px; }
        /* Edit / Cancel action buttons */
        .action-cell { display: flex; gap: 6px; align-items: center; }
        .btn-edit   { background-color: #38bdf8; color: white; border: none; padding: 10px;
                      cursor: pointer; font-family: Arial, sans-serif; font-size: inherit;
                      border-radius: 0; }
        .btn-edit:hover { background-color: #0ea5e9; }
        .btn-delete { background-color: #CC0000; color: white; border: none; padding: 10px;
                      cursor: pointer; font-family: Arial, sans-serif; font-size: inherit;
                      border-radius: 0; }
        .btn-delete:hover { background-color: #a00000; }
        /* Inline edit form panels */
        .edit-panel { display: none; background: #f0f8ff; border: 1px solid #38bdf8;
                      padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        .edit-panel h3 { margin-top: 0; color: #006699; }
        /* Schedule email validation error */
        .schedule-error { color: #dc2626; font-family: Arial, sans-serif; font-size: 0.95em;
                          font-weight: bold; margin-top: 10px; margin-bottom: 0; }
        /* Shared dropdown styling — matches adjacent text inputs */
        select.filter-select { font-family: Arial, sans-serif; font-size: 1em;
                               padding: 4px 6px; border: 1px solid #ccc; border-radius: 0;
                               height: 28px; vertical-align: middle; }
        /* Report generation toolbar */
        .report-toolbar { display: flex; flex-wrap: wrap; align-items: flex-end;
                          gap: 8px; margin-top: 12px; }
        .label-group { display: flex; flex-direction: column; gap: 4px; }
        .label-group label { font-size: 0.9em; font-weight: bold; color: #333; }
        .report-toolbar input[type="date"] { font-family: Arial, sans-serif; font-size: 1em;
                                            padding: 4px 6px; border: 1px solid #ccc;
                                            border-radius: 0; height: 28px;
                                            vertical-align: middle; }
        .report-error { color: #dc2626; font-size: 0.9em; font-weight: bold;
                        margin-top: 4px; display: none; }
    </style>
</head>
<body>

    <h1>Reports &amp; Business Dashboard</h1>

    <c:choose>
        <c:when test="${summary.dataAvailable}">
            <!-- Reflects the parallel view forks from activity.drawio.pdf -->
            <div class="dashboard-grid">
                <div class="card"><h3>Sales Info</h3><p>Total: Rs.${summary.totalSales}</p></div>
                <div class="card"><h3>Stock Availability</h3><p>Items: ${summary.stockItems}</p></div>
                <div class="card"><h3>Pending Orders</h3><p>Count: ${summary.pendingOrders}</p></div>
                <div class="card"><h3>Supplier Deliveries</h3><p>Incoming: ${summary.supplierDeliveries}</p></div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert">Displaying available information only. System records are currently unavailable.</div>
        </c:otherwise>
    </c:choose>

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- Template Management Section                                     -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <div class="section">
        <h2>Manage Report Templates</h2>

        <!-- Create form -->
        <form action="/admin/dashboard/templates/create" method="post" style="margin-bottom: 8px;">
            <input type="text" name="templateName" placeholder="Template Name" required
                   value="${not empty enteredName ? enteredName : ''}" />
            <select name="templateFilters" class="filter-select" required>
                <option value="" disabled ${empty enteredFilters ? 'selected' : ''}>Select Category</option>
                <option value="Sales"     ${enteredFilters == 'Sales'     ? 'selected' : ''}>Sales</option>
                <option value="Inventory" ${enteredFilters == 'Inventory' ? 'selected' : ''}>Inventory</option>
                <option value="Suppliers" ${enteredFilters == 'Suppliers' ? 'selected' : ''}>Suppliers</option>
                <option value="Employees" ${enteredFilters == 'Employees' ? 'selected' : ''}>Employees</option>
                <option value="Orders"    ${enteredFilters == 'Orders'    ? 'selected' : ''}>Orders</option>
            </select>
            <button type="submit">Create Custom Template</button>
        </form>
        <!-- Duplicate / blank-name error for Create form -->
        <c:if test="${not empty templateError}">
            <p style="color:#dc2626; font-family:Arial,sans-serif; font-size:0.95em;
                      font-weight:bold; margin:0 0 14px 0;">${templateError}</p>
        </c:if>

        <!-- Inline Edit form -->
        <c:if test="${not empty templateEditError}">
            <div class="alert">${templateEditError}</div>
        </c:if>
        <div id="editTemplatePanel" class="edit-panel">
            <h3>Edit Template</h3>
            <form id="editTemplateForm" action="" method="post">
                <input type="text" id="editTemplateName" name="templateName" placeholder="Template Name" required />
                <select id="editTemplateFilters" name="templateFilters" class="filter-select" required>
                    <option value="Sales">Sales</option>
                    <option value="Inventory">Inventory</option>
                    <option value="Suppliers">Suppliers</option>
                    <option value="Employees">Employees</option>
                    <option value="Orders">Orders</option>
                </select>
                <button type="submit" style="background-color: #38bdf8;">Update Template</button>
                <button type="button" onclick="closePanel('editTemplatePanel')" style="background-color: #888; margin-left: 6px;">Cancel</button>
            </form>
        </div>

        <!-- Templates table -->
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Filters</th>
                <th>Action</th>
            </tr>
            <c:forEach var="template" items="${templates}">
                <tr>
                    <td>${template.id}</td>
                    <td>${template.templateName}</td>
                    <td>${template.templateFilters}</td>
                    <td>
                        <div class="action-cell">
                            <button type="button" class="btn-edit"
                                    onclick="openTemplateEdit(${template.id},
                                                              '${template.templateName}',
                                                              '${template.templateFilters}')">Edit</button>
                            <form action="/admin/dashboard/templates/delete/${template.id}" method="post" style="margin:0;">
                                <button type="submit" class="btn-delete">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- Generate Report Section                                         -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <div class="section">
        <h2>Generate Report</h2>

        <c:if test="${not empty reportMessage}">
            <div class="alert" style="margin-bottom: 10px;">${reportMessage}</div>
        </c:if>

        <form id="generateReportForm" action="/admin/dashboard/reports/generate" method="post"
              onsubmit="return validateReportForm()">
            <div class="report-toolbar">
                <div class="label-group">
                    <label for="reportTemplateId">Report type</label>
                    <select id="reportTemplateId" name="templateId" class="filter-select" required>
                        <option value="" disabled selected>Select Template</option>
                        <c:forEach var="tpl" items="${templates}">
                            <option value="${tpl.id}">${tpl.templateName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="label-group">
                    <label for="reportFromDate">From</label>
                    <input type="date" id="reportFromDate" name="fromDate" title="From Date" required />
                </div>
                <div class="label-group">
                    <label for="reportToDate">To</label>
                    <input type="date" id="reportToDate" name="toDate" title="To Date" required />
                </div>
                <button type="submit">Generate Report</button>
            </div>
            <span id="reportFormErr" class="report-error"></span>
        </form>
    </div>

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- Schedule Management Section                                     -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <div class="section">
        <h2>Manage Report Schedules</h2>

        <!-- Create form: Report Type is now a dynamic template dropdown -->
        <form id="scheduleCreateForm" action="/admin/dashboard/schedules/create" method="post"
              style="margin-bottom: 20px;" onsubmit="return validateScheduleEmail('scheduleCreateEmail', 'scheduleCreateEmailErr')">
            <select name="templateId" class="filter-select" required>
                <option value="" disabled selected>Select Template</option>
                <c:forEach var="tpl" items="${templates}">
                    <option value="${tpl.id}">${tpl.templateName}</option>
                </c:forEach>
            </select>
            <select name="frequency" class="filter-select">
                <option value="Daily">Daily</option>
                <option value="Weekly">Weekly</option>
                <option value="Monthly">Monthly</option>
            </select>
            <input type="text" id="scheduleCreateEmail" name="deliveryEmail" placeholder="Delivery Email" required />
            <button type="submit">Create Schedule</button>
        </form>
        <span id="scheduleCreateEmailErr" class="schedule-error" style="display:none;">Invalid Email</span>

        <!-- Inline Edit form -->
        <c:if test="${not empty scheduleEditError}">
            <div class="alert">${scheduleEditError}</div>
        </c:if>
        <div id="editSchedulePanel" class="edit-panel">
            <h3>Edit Schedule</h3>
            <form id="editScheduleForm" action="" method="post"
                  onsubmit="return validateScheduleEmail('editScheduleDeliveryEmail', 'editScheduleEmailErr')">
                <!-- Hidden field carries the resolved templateId back to the controller -->
                <input type="hidden" id="editScheduleTemplateId" name="templateId" />
                <select id="editScheduleTemplateSelect" class="filter-select" required
                        onchange="document.getElementById('editScheduleTemplateId').value = this.value">
                    <c:forEach var="tpl" items="${templates}">
                        <option value="${tpl.id}">${tpl.templateName}</option>
                    </c:forEach>
                </select>
                <select id="editScheduleFrequency" name="frequency" class="filter-select">
                    <option value="Daily">Daily</option>
                    <option value="Weekly">Weekly</option>
                    <option value="Monthly">Monthly</option>
                </select>
                <input type="text" id="editScheduleDeliveryEmail" name="deliveryEmail" placeholder="Delivery Email" required />
                <button type="submit" style="background-color: #38bdf8;">Update Schedule</button>
                <button type="button" onclick="closePanel('editSchedulePanel')" style="background-color: #888; margin-left: 6px;">Cancel</button>
            </form>
            <span id="editScheduleEmailErr" class="schedule-error" style="display:none;">Invalid Email</span>
        </div>

        <!-- Schedules table -->
        <table>
            <tr>
                <th>ID</th>
                <th>Report Type (Template)</th>
                <th>Frequency</th>
                <th>Email</th>
                <th>Action</th>
            </tr>
            <c:forEach var="schedule" items="${schedules}">
                <tr>
                    <td>${schedule.id}</td>
                    <td>${schedule.template.templateName}</td>
                    <td>${schedule.frequency}</td>
                    <td>${schedule.deliveryEmail}</td>
                    <td>
                        <div class="action-cell">
                            <button type="button" class="btn-edit"
                                    onclick="openScheduleEdit(${schedule.id},
                                                              ${schedule.template.id},
                                                              '${schedule.frequency}',
                                                              '${schedule.deliveryEmail}')">Edit</button>
                            <form action="/admin/dashboard/schedules/cancel/${schedule.id}" method="post" style="margin:0;">
                                <button type="submit" class="btn-delete">Cancel</button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <!-- Server-side validation error — rendered below the schedules table -->
        <c:if test="${not empty scheduleEmailError}">
            <p class="schedule-error">${scheduleEmailError}</p>
        </c:if>
    </div>

    <script>
        /* ---- Shared helpers ---- */
        function closePanel(panelId) {
            document.getElementById(panelId).style.display = 'none';
        }
        function openPanel(panelId) {
            var panel = document.getElementById(panelId);
            panel.style.display = 'block';
            panel.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        /* ---- Email validation (create & edit schedule forms) ---- */
        function validateScheduleEmail(inputId, errSpanId) {
            var emailVal = document.getElementById(inputId).value;
            var errSpan  = document.getElementById(errSpanId);
            if (!emailVal || emailVal.indexOf('@') === -1) {
                errSpan.style.display = 'inline';
                return false;
            }
            errSpan.style.display = 'none';
            return true;
        }

        /* ---- Template edit ---- */
        function openTemplateEdit(id, name, filters) {
            document.getElementById('editTemplateForm').action =
                '/admin/dashboard/templates/update/' + id;
            document.getElementById('editTemplateName').value = name;
            var sel = document.getElementById('editTemplateFilters');
            for (var i = 0; i < sel.options.length; i++) {
                if (sel.options[i].value === filters) { sel.selectedIndex = i; break; }
            }
            openPanel('editTemplatePanel');
        }

        /* ---- Schedule edit ---- */
        function openScheduleEdit(id, templateId, frequency, email) {
            document.getElementById('editScheduleForm').action =
                '/admin/dashboard/schedules/update/' + id;

            // Pre-select the template in the visible <select> and sync the hidden input
            var tplSel = document.getElementById('editScheduleTemplateSelect');
            for (var i = 0; i < tplSel.options.length; i++) {
                if (parseInt(tplSel.options[i].value) === templateId) {
                    tplSel.selectedIndex = i;
                    break;
                }
            }
            document.getElementById('editScheduleTemplateId').value = templateId;

            // Pre-select frequency
            var freqSel = document.getElementById('editScheduleFrequency');
            for (var j = 0; j < freqSel.options.length; j++) {
                if (freqSel.options[j].value === frequency) { freqSel.selectedIndex = j; break; }
            }

            document.getElementById('editScheduleDeliveryEmail').value = email;
            openPanel('editSchedulePanel');
        }

        /* ---- Report generation form validation ---- */
        function validateReportForm() {
            var errSpan = document.getElementById('reportFormErr');
            var tplVal  = document.getElementById('reportTemplateId').value;
            var from    = document.getElementById('reportFromDate').value;
            var to      = document.getElementById('reportToDate').value;

            if (!tplVal) {
                errSpan.textContent = 'Please select a template.';
                errSpan.style.display = 'block';
                return false;
            }
            if (!from || !to) {
                errSpan.textContent = 'Please select both a start date and an end date.';
                errSpan.style.display = 'block';
                return false;
            }
            if (from > to) {
                errSpan.textContent = 'Start date must not be later than end date.';
                errSpan.style.display = 'block';
                return false;
            }
            errSpan.style.display = 'none';
            return true;
        }
    </script>

</body>
</html>