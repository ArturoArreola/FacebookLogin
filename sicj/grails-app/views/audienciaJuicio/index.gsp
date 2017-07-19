<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <!-- Clock picker -->
        <g:external dir="assets/plugins/clockpicker" file="clockpicker.css" />
        <g:external dir="assets/plugins/clockpicker" file="clockpicker.js" />
        <!-- html2canvas -->
        <script src="/sicj/assets/plugins/html2canvas/html2canvas.js" type="text/javascript" dir="assets/plugins/html2canvas" file="html2canvas.js"></script>
        <!-- jsPDF -->
        <script src="/sicj/assets/plugins/jsPDF/jspdf.min.js" type="text/javascript" dir="assets/plugins/jsPDF" file="jspdf.min.js"></script>
        <script src="/sicj/assets/plugins/jsPDF/plugins/addimage.js" type="text/javascript" dir="assets/plugins/jsPDF/plugins" file="addimage.js"></script>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Calendario de Audiencias</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Calendario de Audiencias</a>
                    </li>
                    <li class="active">
                        <strong>Index</strong>
                    </li>
                </ol>
            </div>
        </div>
        <br/>
        <div class="wrapper wrapper-content">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Calendario de Audiencias</h5>
                        </div>
                        <div class="ibox-content">
                            <div clas="row">
                                <center>
                                    <span class="badge" style="background: #f8ac59; color: #ffffff;">Activas</span>&nbsp;&nbsp;<span class="badge" style="background: #1ab394; color: #ffffff;">Atendidas</span>
                                </center>
                            </div>
                            <g:render template="/templates/calendarioDeAudiencias" />
                            <div class="row text-center">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <button type="button" class="btn btn-success" onclick="getReporteDeAudiencias();"><i class="fa fa-print"></i> Generar Reporte </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal inmodal fade" id="modalReporteAudiencias" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width: 80%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                        <h5 class="modal-title">Audiencias Programadas</h5>
                    </div>
                    <div class="modal-body">
                        <div id="divReporteAudiencias" class="row">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal inmodal fade" id="modalDetalleAudiencia" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width: 80%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                        <h5 class="modal-title">Detalle de Audiencia</h5>
                    </div>
                    <div class="modal-body">
                        <div id="divDetalleAudiencia" class="row">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
        <style>
            body.modal-open .datepicker {
            z-index: 100000 !important;
            }

            .popover.clockpicker-popover{
            z-index: 999999 !important;
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function() {

            $('.i-checks').iCheck({
            checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green'
            });

            /* initialize the calendar
            -----------------------------------------------------------------*/
            var date = new Date();
            var d = date.getDate();
            var m = date.getMonth();
            var y = date.getFullYear();

            $('#calendar').fullCalendar({
            header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
            },
            weekends: false,
            timezone: 'local',
            editable: false,
            events: {
            url: '/sicj/dashboard/getAudiencias',
            type: 'POST',
            data: {
            tipo: 'reales',
            vista: 'dashboard'
            },
            error: function() {
            alert('Ocurrio un error al cargar las fechas de audiencia.');
            }
            },
            eventClick:  function(calEvent, jsEvent, view) {
            mostrarDetallesAudiencia(calEvent.id);
            return false;
            }
            });
            });

            function mostrarModal(modal){
            $('#'+modal).modal('show');
            }

            function ocultarModal(modal){
            $('#'+modal).modal('hide');
            }

            function mostrarDetallesAudiencia(idAudiencia){
            jQuery.ajax({
            type:'POST',
            data:'audienciaId=' + idAudiencia + '&vista=porJuicio',
            url:'/sicj/audienciaJuicio/obtenerDetallesAudiencia',
            success:function(data,textStatus){
            $('#divDetalleAudiencia').html(data);
            mostrarModal('modalDetalleAudiencia');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function editarAudiencia(){
            $('#verAudiencia').hide('slow');
            $('#btnDetalles').hide('slow');
            $('#editarAudiencia').show('slow');
            $('#hora').clockpicker({
            autoclose: true
            });
            $('#fechaAud').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            todayHighlight: true,
            calendarWeeks: true,
            autoclose: true
            });
            }

            function mostrarOcultarMotivo(){
            if($('input[name=diferirAudiencia]').is(':checked')){
            $('#reprogramacion').show('slow');
            } else {
            $('#reprogramacion').hide('slow');
            }
            }

            function mostrarAudiencia(data){
            var resultado = (data);
            if(resultado.error){
            var html = "<center><div class='alert alert-danger alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>" + data.error + "</div></center>";
            $('#mensajesAudiencia').html(html);
            } else if(resultado.mensaje){
            var html = "<center><div class='alert alert-info alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>" + resultado.mensaje + "</div></center>";
            $('#mensajesAudiencia').html(html);
            } else{
            $("#calendar").fullCalendar('renderEvent', eval(data) ,true);
            $("#calendar").fullCalendar('removeEvents', resultado.anterior);
            $("#calendar").fullCalendar('refresh');
            $("#modalAltaAudiencia").modal('hide');
            }
            }
            
            function getReporteDeAudiencias(){
            var start, end;
            start = $('#calendar').fullCalendar('getView').start;
            start = start.format();
            end = $('#calendar').fullCalendar('getView').end;
            end = end.format();
            jQuery.ajax({
            type:'POST',
            data:'tipo=reales&start=' + start + "&end=" + end,
            url:'/sicj/dashboard/getReporteDeAudiencias',
            success:function(data,textStatus){
            $('#divReporteAudiencias').html(data);
            $('#tituloDelMes').html($('#calendar').fullCalendar('getView').title);
            mostrarModal('modalReporteAudiencias');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }
            
            function exportarReporteAudiencias(){
            console.log("Si entra a exportarReporteAudiencias: ");
            var pdf = new jsPDF('l', 'pt', 'letter');
            pdf.addHTML($('#contenidoReporteAudiencias')[0], function () {
            pdf.save('ReporteDeAudiencias.pdf');
            });
            }
        </script>
    </body>
</html>