<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <g:set var="entityName" value="${message(code: 'agenda.label', default: 'Agenda')}" />
        <title><g:message code="Agenda de citas" args="[entityName]" /></title>
        <asset:stylesheet src="bootstrap.min.css"/>
        <asset:stylesheet src="fullcalendar.min.css"/>
        
        <script src="https://code.jquery.com/jquery.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.8.2/moment.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/2.6.1/fullcalendar.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/2.6.1/lang/es.js"></script>
        
    </head>
    <body>
        <a href="#list-agenda" class="skip" tabindex="-1"><g:message code="Agenda de citas" default="Skip to content&hellip;"/></a>
        
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="Agregar nueva cita" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <h1 align="center"><g:message code="Agenda de citas" args="[entityName]" /></h1>
                    <div id="bootstrapModalFullCalendar">
                    </div>
                </div>
            </div>
        </div>
        
        <div id="fullCalModal" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span> <span class="sr-only">close</span></button>
                        <h4 id="modalTitle" class="modal-title" align="center"></h4>
                    </div>
                    <div id="modalBody" class="modal-body">
                        <h5 id="modalTitle" class = "modal-start">
                        </h5>
                        <h5 id="modalTitle" class = "modal-end">
                        </h5>
                    </div>
                    <div class="modal-footer">
                        <g:link class="reporte " action="reporte" id="reporte.pdf">
                            <g:message code="Reporte" />
                        </g:link>
                        <button type="button" class="btn btn-default" action="reporte"  data-dismiss="modal">
                            Generar reporte
                        </button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal">   
                            Cancelar
                        </button>
                        <g:actionSubmit class="btn btn-primary actualizar-datos" action="index" value="Actualizar cita" href="#" data-toggle="modal" data-target="#actualizar-datos" data-dismiss="modal"/>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="modal fade actualizar-datos" id="actualizar-datos" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
            <g:render template="/templates/crearCita" />          
        </div>
        
        <div id="list-agenda" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
             </g:if>
            <f:table collection="${agendaList}" />
            <div class="pagination">
                <g:paginate total="${agendaCount ?: 0}" />
            </div>
            <g:each var="variable" in="${agendaList}">
                <p id="titulo">Titulo: ${variable.titulo}</p>
                <p id="descripcion">Descripcion: ${variable.descripcion}</p>
                <p id="lugar">Lugar: ${variable.lugar}</p>
                <p id="inicio">Inicio de la cita: ${variable.inicio_cita}</p>
                <p id="fin">Fin de la cita: ${variable.fin_cita}</p>
            </g:each>
        </div>
        <a onclick="imprimir()">bvhjfkdgvkfdbjkvgfdkjbkjvfdbnjknfgdskjgbjkdnjdf</a>
        
        
        <script>
        function imprimir ()
        {
            $.ajax(
            {
                url: "datos",
                type: 'POST',
                success: function(data) 
                {
                    console.log(data) 
                },
                error: function(data) 
                {
                    console.log(data)
                }
            });
            }
        $(document).ready(function() 
        {
            $('#bootstrapModalFullCalendar').fullCalendar(
            {
                header: 
                {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'        
                },
                editable: true,
                selectable: true,
                
                eventClick: function(event, jsEvent, view) 
                {
                    $('#modalTitle').html(event.titulo);
                    $('#modalBody').html("La cita comienza a las: " + moment(event.inicio).format('DD MMM h:mm A') + "\n " + " y concluye a las: " + moment(event.fin).format('DD MMM h:mm A') + ". " + event.descripcion + ". " + event.lugar);
                    $('#eventUrl').attr;
                    $('#fullCalModal').modal();
                    return false;
                },
                events:
                [   
                   {
                      "titulo":"Prueba",
                      "allday":"",
                      "description":"<p></p>",
                      "start":moment().subtract('days',1),
                      "end":moment().subtract('days',1),
                      "lugar":"hola"
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
            font-size: 12px;
        }
        #bootstrapModalFullCalendar
        {
            max-width: 700px;
            margin: 0 auto;
        }	
        #bootstrapModalFullCalendar .fc-content
        {
            color: white;
        }
        #bootstrapModalFullCalendar .fc-widget.content:hover, fc-row: hover, fc-week:hover
        {
            color: white;
        }
        a:link, a:visited, a:hover 
        {
            color: white;
        }
        </style>
    </body>
</html>