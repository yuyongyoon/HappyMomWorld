<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth'
    });
    calendar.render();
});
</script>


<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-8">
					<div class="card">
						<div class="card-body">
							<div id='calendar'></div>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card">
						<div class="card-body pb-0">
							<h4 class="mb-1 fw-bold">Tasks Progress</h4>
							<div id="task-complete" class="chart-circle mt-4 mb-3"></div>
						</div>
					</div>
					<div class="card">
						<div class="card-body">
							<h4 class="mb-1 fw-bold">Tasks Progress</h4>
							<div id="task-complete" class="chart-circle mt-4 mb-3"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>