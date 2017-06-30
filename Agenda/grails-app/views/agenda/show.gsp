<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        
        <asset:javascript src="moment.min.js"/>
        <asset:javascript src="jquery.min.js"/>
        <asset:javascript src="fullcalendar.min.js"/>
        <asset:stylesheet src="fullcalendar.css"/>
        <asset:stylesheet src="fullcalendar.print.css" media="print"/>
        
        <!--link href='../../assets/stylesheets/fullcalendar.css' rel='stylesheet' -->
        <!--link href='../../assets/stylesheets/fullcalendar.print.css' rel='stylesheet' media='print' -->
        <!--script src='../../assets/javascripts/moment.min.js'></script-->
        <!--script src='../../assets/javascripts/lib/jquery.min.js'></script-->
        <!--script src='../../assets/javascripts/fullcalendar.min.js'></script-->
             
        <script>
	$(document).ready(function() 
        {	
		$('#calendar').fullCalendar(
                {
                    header: 
                    {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    defaultDate: '2016-01-12',
                    editable: true,
                    eventLimit: true, // allow "more" link when too many events
                    events: 
                    [
                        {
                            
                        
                            <?php foreach ($eventos as $evento): ?>
                            {
                                id: <?php echo $evento['id']; ?>,
                                title: <?php echo $evento['title']; ?>,
                                // otros datos
                            },
                            <?php endforeach; ?>

                        
                        
                        },
                        {
                            title: 'Long Event',
                            start: '2016-03-07',
                            end: '2016-03-10'
                        },
                        {
                            id: 999,
                            title: 'Repeating Event',
                            start: '2016-03-09T16:00:00'
                        },
                        {
                            id: 999,
                            title: 'Repeating Event',
                            start: '2016-03-16T16:00:00'
                        },
                        {
                            title: 'Conference',
                            start: '2016-03-11',
                            end: '2016-03-13'
                        },
                        {
                            title: 'Meeting',
                            start: '2016-03-12T10:30:00',
                            end: '2016-03-12T12:30:00'
                        },
                        {
                            title: 'Lunch',
                            start: '2016-03-12T12:00:00'
                        },
                        {
                            title: 'Meeting',
                            start: '2016-03-12T14:30:00'
                        },
                        {
                            title: 'Happy Hour',
                            start: '2016-03-12T17:30:00'
                        },
                        {
                            title: 'Dinner',
                            start: '2016-03-12T20:00:00'
                        },
                        {
                            title: 'Birthday Party',
                            start: '2016-03-13T07:00:00'
                        },
                        {
                            title: 'Click for Google',
                            url: 'http://google.com/',
                            start: '2016-03-28'
                        }
                    ]
                });
            });
        </script>
        <style>
            body 
            {
                margin: 40px 10px;
                padding: 0;
                font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
                font-size: 14px;
            }
            #calendar 
            {
                max-width: 900px;
                margin: 0 auto;
            }
        </style>
        <g:set var="entityName" value="${message(code: 'agenda.label', default: 'Agenda')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>   
    </head>
    <body>
        <a href="#show-agenda" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        
        <div id="calendar"></div>
        
        <div id="show-agenda" class="content scaffold-show" role="main">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:display bean="agenda" />
            <g:form resource="${this.agenda}" method="DELETE">
                <fieldset class="buttons">
                    <g:link class="edit" action="edit" resource="${this.agenda}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                    <input class="delete" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                </fieldset>
            </g:form>
        </div>
    </body>
</html>