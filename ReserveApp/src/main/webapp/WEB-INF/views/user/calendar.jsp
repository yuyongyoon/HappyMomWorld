<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/static/common/fullcalendar-6.1.8/dist/index.global.js"></script>

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
			<div id='calendar'></div>
		</div>
	</div>
</div>