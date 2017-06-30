<!DOCTYPE html>
<%@ page import="demo.Responsable" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <g:set var="entityName" value="${message(code: 'agenda.label', default: 'Agenda')}" />
        <title><g:message code="Crear nueva cita" args="[entityName]" /></title>
        <asset:stylesheet src="bootstrap.min.css"/>
        <asset:stylesheet src="fullcalendar.min.css"/>
        
        <script src="https://code.jquery.com/jquery.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.8.2/moment.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/2.6.1/fullcalendar.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/2.6.1/lang/es.js"></script>
    
    </head>
    <body>
        <a href="#create-agenda" class="skip" tabindex="-1"><g:message code="Agendar nueva cita" default="Skip to content&hellip;"/></a>
    
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="Agenda de citas" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        
        <div id="create-agenda" class="content scaffold-create" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.agenda}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${this.agenda}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
                </ul>
            </g:hasErrors>
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <h1 align="center"><g:message code="Agendar nueva cita" args="[entityName]" /></h1>
                        <div id="bootstrapModalFullCalendar"></div>
                    </div>
                </div>
            </div>
            <div id="fullCalModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span> <span class="sr-only">close</span></button>
                            <h3 align ="center" class="modal-title">
                                Datos de la nueva cita
                            </h3>
                            <g:form action="save">
                                <div class="modal-body">
                                    <fieldset class="form">
                                        <!--f:all bean="agenda"/-->
                                        <f:field bean = "agenda" property = "titulo" id= "titulo" />
                                        <f:field bean = "agenda" property = "descripcion"/>
                                        <f:field bean = "agenda" property = "lugar"/>
                                        <input type="hidden" id="apptStartTime"/>
                                        <input type="hidden" id="apptEndTime"/>
                                        </br>
                                        <label for="responsable">Responsable</label>
                                        <g:select property="responsable" id="responsable" name ="responsable.id" from="${Responsable.list()}" optionKey ="id" value="${agenda.responsable?.id}" />
                                        <f:field bean = "agenda" property = "todo_el_dia" id="apptAllDay"/>
                                    </fieldset>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-danger" data-dismiss="modal">   
                                        Cancelar
                                    </button>
                                    <g:actionSubmit class="btn btn-primary" action="save" value="Guardar" />
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
        $(document).ready(function() 
        {
            $('#bootstrapModalFullCalendar').fullCalendar(
            {
                defaultView: 'agendaWeek', 
                header: 
                {   
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'   
                },
                editable: true,
                selectable: true,
                select:function(start, end, allDay)
                {
//                      endtime = $.fullCalendar.formatDate(end,'h:mm tt');
//                      starttime = $.fullCalendar.formatDate(start,'ddd, MMM d, h:mm tt');
//                      var mywhen = starttime + ' - ' + endtime;
                    $('#fullCalModal #apptStartTime').val(start);
                    $('#fullCalModal #apptEndTime').val(end);
                    $('#fullCalModal #apptAllDay').val(allDay);
                    $('#fullCalModal #when').text("mywhen");
        
//                  $('#modalTitle').html(event.title);
//                  $('#modalBody').html(event.description);
//                  $('#eventUrl').attr('href',event.url);
                    $('#fullCalModal').modal();
                },
                eventClick:  function(event, jsEvent, view) 
                {
                    $('#modalTitle').html(event.title);
                    $('#modalBody').html(event.description);
                    $('#eventUrl').attr('href',event.url);
                    $('#fullCalModal').modal();
                    return false;
                },
                events:
                [
                   {
                      "title":"Javascript ",
                      "allday":"false",
                      "description":"",
                      "start":moment().subtract('days',2),
                      "end":moment().subtract('days',2),
                      "url":""
                   },
                   {
                      "title":"HTML Meetup",
                      "allday":"false",
                      "description":"",
                      "start":moment().subtract('days',3),
                      "end":moment().subtract('days',3),
                      "url":""
                   },
                   {
                      "title":"CSS Meetup",
                      "allday":"false",
                      "description":"<p>This is just a fake description for the CSS Meetup.</p><p>Nothing to see!</p>",
                      "start":moment().add('days',1),
                      "end":moment().add('days',1),
                      "url":""
                   }
                ]
            });
            $('#submitButton').on('click', function(e){
                e.preventDefault();
                doSubmit();
            });

            function doSubmit()                     // Bloque de código para pintar las citas en el calendario
            {
                $("#fullCalModal").modal('hide');
                console.log($('#apptStartTime').val());
                console.log($('#apptEndTime').val());
                console.log($('#apptAllDay').val());
                alert("La cita se dio de alta exitosamente");
            
                $("#bootstrapModalFullCalendar").fullCalendar('renderEvent',
                {
                    title: $('#titulo').val(),
                    start: new Date($('#apptStartTime').val()),
                    end: new Date($('#apptEndTime').val()),
                    allDay: ($('#apptAllDay').val() == "true")
                },
                true);
            }
        });
        </script>
        
        <style>
        body 
        {
            margin: 40px 10px;
            padding: 0;
            font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
            font-size: 12px;
        }
        #bootstrapModalFullCalendar
        {
            max-width: 700px;
            margin: 0 auto;
        }
        #bootstrapModalFullCalendar .fc-widget-header:hover
        {
            backgroud: white;
        }
        #bootstrapModalFullCalendar .fc-widget-content:hover
        {
            backgroud: white;
        }
        #bootstrapModalFullCalendar .fc-content
        {
            color: white;
        }
        </style>
    </body>
</html>