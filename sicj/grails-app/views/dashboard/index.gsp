<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <!-- Flot -->
        <script src="/sicj/assets/plugins/flot/jquery.flot.js" type="text/javascript" dir="assets/plugins/flot" file="jquery.flot.js"></script>
        <script src="/sicj/assets/plugins/flot/jquery.flot.tooltip.min.js" type="text/javascript" dir="assets/plugins/flot" file="jquery.flot.tooltip.min.js"></script>
        <script src="/sicj/assets/plugins/flot/jquery.flot.resize.js" type="text/javascript" dir="assets/plugins/flot" file="jquery.flot.resize.js"></script>
        <script src="/sicj/assets/plugins/flot/jquery.flot.pie.js" type="text/javascript" dir="assets/plugins/flot" file="jquery.flot.pie.js"></script>
        <script src="/sicj/assets/plugins/flot/jquery.flot.time.js" type="text/javascript" dir="assets/plugins/flot" file="jquery.flot.time.js"></script>
                <!-- Clock picker -->
        <link href="/sicj/assets/plugins/clockpicker/clockpicker.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/clockpicker" file="clockpicker.css">
        <script src="/sicj/assets/plugins/clockpicker/clockpicker.js" type="text/javascript" dir="assets/plugins/clockpicker" file="clockpicker.js"></script>
                    <!-- Data Tables -->
        <link href="/sicj/assets/plugins/dataTables/dataTables.bootstrap.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="dataTables.bootstrap.css">
        <link href="/sicj/assets/plugins/dataTables/dataTables.responsive.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="dataTables.responsive.css">
        <link href="/sicj/assets/plugins/dataTables/dataTables.tableTools.min.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="dataTables.tableTools.min.css">
        <link href="/sicj/assets/plugins/dataTables/buttons.dataTables.min.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="buttons.dataTables.min.css">
        <script src="/sicj/assets/plugins/dataTables/latest/jquery.dataTables.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="jquery.dataTables.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/dataTables.buttons.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="dataTables.buttons.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/buttons.flash.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="buttons.flash.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/jszip.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="jszip.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/pdfmake.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="pdfmake.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/vfs_fonts.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="vfs_fonts.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/buttons.html5.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="buttons.html5.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/latest/buttons.print.min.js" type="text/javascript" dir="assets/plugins/dataTables/latest" file="buttons.print.min.js"></script>
        <script src="/sicj/assets/plugins/dataTables/dataTables.bootstrap.js" type="text/javascript" dir="assets/plugins/dataTables" file="dataTables.bootstrap.js"></script>
        <script src="/sicj/assets/plugins/dataTables/dataTables.responsive.js" type="text/javascript" dir="assets/plugins/dataTables" file="dataTables.responsive.js"></script>
        <script src="/sicj/assets/plugins/dataTables/dataTables.tableTools.min.js" type="text/javascript" dir="assets/plugins/dataTables" file="dataTables.tableTools.min.js"></script>
        <!-- html2canvas -->
        <script src="/sicj/assets/plugins/html2canvas/html2canvas.js" type="text/javascript" dir="assets/plugins/html2canvas" file="html2canvas.js"></script>
        <!-- jsPDF -->
        <script src="/sicj/assets/plugins/jsPDF/jspdf.min.js" type="text/javascript" dir="assets/plugins/jsPDF" file="jspdf.min.js"></script>
        <script src="/sicj/assets/plugins/jsPDF/plugins/addimage.js" type="text/javascript" dir="assets/plugins/jsPDF/plugins" file="addimage.js"></script>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Tablero de Control</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/dashboard">Tablero de Control</a>
                    </li>
                    <li class="active">
                        <strong>Index</strong>
                    </li>
                </ol>
            </div>
        </div>
        <br/>
        <div class="wrapper wrapper-content">
            <sec:ifAnyGranted roles='ROLE_ADMIN, ROLE_LABORAL'>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Estadística de Juicios - Laboral</h5>
                            </div>
                            <div class="ibox-content" id='divLaboralStats'>
                                <div class="row">
                                    <div class="flot-chart col-md-6">
                                        <div class="flot-chart-pie-content" id="asuntosActualesLaboralChart"></div>
                                    </div>
                                    <div id="asuntosActualesLaboralLegends" class="col-md-6">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Contingencia - Laboral</h5>
                            </div>
                            <div class="ibox-content" id='divLaboralCont'>
                                <div class="row">
                                    <div class="flot-chart col-md-6">
                                        <div class="flot-chart-pie-content" id="contingenciaLaboralChart"></div>
                                    </div>
                                    <div id="contingenciaLaboralLegends" class="col-md-6">
                                    </div>
                                </div>
                                <br/>
                                <div class='row text-center'>
                                    <button type='button' class='btn btn-danger' onclick='obtenerJuiciosContingentes(1);'>Ver Asuntos Contingentes</button>
                                </div>
                                <br/>
                            </div>
                        </div>
                    </div>
                </div>
            </sec:ifAnyGranted>
            <sec:ifAnyGranted roles='ROLE_ADMIN, ROLE_CIVIL'>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Estadística de Juicios - Civil/Mercantil</h5>
                            </div>
                            <div class="ibox-content" id='divCivilStats'>
                                <div class="row">
                                    <div class="flot-chart col-md-6">
                                        <div class="flot-chart-pie-content" id="asuntosActualesCivilChart"></div>
                                    </div>
                                    <div id="asuntosActualesCivilLegends" class="col-md-6">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Contingencia - Civil Mercantil</h5>
                            </div>
                            <div class="ibox-content" id='divCivilCont'>
                                <div class="row">
                                    <div class="flot-chart col-md-6">
                                        <div class="flot-chart-pie-content" id="contingenciaCivilChart"></div>
                                    </div>
                                    <div id="contingenciaCivilLegends" class="col-md-6">
                                    </div>
                                </div>
                                <br/>
                                <div class='row text-center'>
                                    <button type='button' class='btn btn-danger' onclick='obtenerJuiciosContingentes(2);'>Ver Asuntos Contingentes</button>
                                </div>
                                <br/>
                            </div>
                        </div>
                    </div>
                </div>
            </sec:ifAnyGranted>
            <sec:ifAnyGranted roles='ROLE_ADMIN, ROLE_PENAL'>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Estadística de Juicios - Penal</h5>
                            </div>
                            <div class="ibox-content" id='divPenalStats'>
                                <div class="row">
                                    <div class="flot-chart col-md-6">
                                        <div class="flot-chart-pie-content" id="asuntosActualesPenalChart"></div>
                                    </div>
                                    <div id="asuntosActualesPenalLegends" class="col-md-6">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Contingencia - Penal</h5>
                            </div>
                            <div class="ibox-content" id='divPenalCont'>
                                <div class="row">
                                    <div class="flot-chart col-md-6">
                                        <div class="flot-chart-pie-content" id="contingenciaPenalChart"></div>
                                    </div>
                                    <div id="contingenciaPenalLegends" class="col-md-6">
                                    </div>
                                </div>
                                <br/>
                                <div class='row text-center'>
                                    <button type='button' class='btn btn-danger' onclick='obtenerJuiciosContingentes(3);'>Ver Asuntos Contingentes</button>
                                </div>
                                <br/>
                            </div>
                        </div>
                    </div>
                </div>
            </sec:ifAnyGranted>
            <div class="row">
                <div class="col-lg-5">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-success pull-right">${mesActual}</span>
                                <h5>Asuntos Dados de Alta en el Mes</h5>
                            </div>
                            <div class="ibox-content text-center">
                                <table class='table table-stripped'>
                                    <thead>
                                        <tr>
                                            <g:each var='asunto' in='${asuntosDadosDeAlta}'>
                                                <th style="text-align: center;">
                                                    <g:if test="${asunto.materia.nombre.equals('REZAGO HISTORICO')}">
                                                    </g:if>
                                                    <g:else>
                                                        <h4 class="no-margins text-center"><strong>${asunto.materia.nombre.capitalize()}</strong></h4>
                                                    </g:else>
                                                </th>
                                            </g:each>
                                            <th>
                                                <h4 class="no-margins text-center"><strong>Total</strong></h4>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <% def totalAsuntos = 0%>
                                            <g:each var='asunto' in='${asuntosDadosDeAlta}'>
                                                <td style="text-align: center;">
                                                    <g:if test="${asunto.materia.nombre.equals('REZAGO HISTORICO')}">
                                                    </g:if>
                                                    <g:else>
                                                        <h4 class="no-margins text-center"><strong>${asunto.cantidad}</strong></h4>
                                                        <small>Juicios</small>  
                                                    </g:else>
                                                </td>
                                                <% totalAsuntos += asunto.cantidad%>
                                            </g:each>
                                            <td>
                                                <h4 class="no-margins text-center"><strong>${totalAsuntos}</strong></h4>
                                                <small>Juicios</small>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-success pull-right">${mesActual}</span>
                                <h5>Asuntos Dados de Baja en el Mes</h5>
                            </div>
                            <div class="ibox-content text-center">
                                <table class='table table-stripped'>
                                    <thead>
                                        <tr>
                                            <g:each var='asunto' in='${asuntosDadosDeBaja}'>
                                                <th style="text-align: center;">
                                                    <g:if test="${asunto.materia.nombre.equals('REZAGO HISTORICO')}">
                                                    </g:if>
                                                    <g:else>
                                                        <h4 class="no-margins text-center"><strong>${asunto.materia.nombre.capitalize()}</strong></h4>
                                                    </g:else>
                                                </th>
                                            </g:each>
                                            <th>
                                                <h4 class="no-margins text-center"><strong>Total</strong></h4>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <% def totalAsuntosBaja = 0%>
                                            <g:each var='asunto' in='${asuntosDadosDeBaja}'>
                                                <td style="text-align: center;">
                                                    <g:if test="${asunto.materia.nombre.equals('REZAGO HISTORICO')}">
                                                    </g:if>
                                                    <g:else>
                                                        <h4 class="no-margins text-center"><strong>${asunto.cantidad}</strong></h4>
                                                        <small>Juicios</small>  
                                                    </g:else>
                                                </td>
                                                <% totalAsuntos += asunto.cantidad%>
                                            </g:each>
                                            <td>
                                                <h4 class="no-margins text-center"><strong>${totalAsuntosBaja}</strong></h4>
                                                <small>Juicios</small>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Avisos</h5>
                        </div>
                        <div class="ibox-content">
                            <div class="row text-center">
                                <g:if test="${avisos}">
                                    <ul class="notes">
                                        <g:each var='aviso' in='${avisos}'>
                                            <li>
                                                <div>
                                                    <small>${aviso.usuarioQueRegistro.nombre + " " + aviso.usuarioQueRegistro.apellidoPaterno + " " + aviso.usuarioQueRegistro.apellidoMaterno} - <g:formatDate format="dd/MM/yyyy" date="${aviso.fechaDePublicacion}" /></small>
                                                    <h4>${aviso.tituloAviso}</h4>
                                                    <p>${aviso.textoAviso}</p>
                                                </div>
                                            </li>
                                        </g:each>
                                    </ul>
                                </g:if>
                                <g:else>
                                    <div class="widget lazur-bg p-lg text-center">
                                        <div class="m-b-md">
                                            <i class="fa fa-bell fa-4x"></i>
                                            <h1 class="m-xs">0</h1>
                                            <h3 class="font-bold no-margins">
                                                Avisos
                                            </h3>
                                            <h3>No hay avisos para mostrar.</h3>
                                        </div>
                                    </div>
                                </g:else>    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
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
                            <br />
                            <div id="calendar"></div>
                            <br />
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
                <div class="col-lg-4">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Sitios de Interes</h5>
                        </div>
                        <div class="ibox-content">
                            <div class="row text-center">
                                <a class="btn btn-outline btn-success" href="http://www.cjf.gob.mx/" style='width: 100%;' target="_blank">Consejo de la Judicatura Federal</a><br/>
                                <a class="btn btn-outline btn-info" href="https://www.scjn.gob.mx/" style='width: 100%;' target="_blank">Suprema Corte de Justicia de la Nación</a><br/>
                                <a class="btn btn-outline btn-warning" href="http://www.dgepj.cjf.gob.mx/internet/expedientes/exp_ini.asp?Exp=1" style='width: 100%;' target="_blank">Dirección General de Estadística Judicial</a><br/>
                                <a class="btn btn-outline btn-default" href="http://www.stps.gob.mx/bp/secciones/junta_federal/index.html" style='width: 100%;' target="_blank">Junta Federal de Conciliación y Arbitraje</a><br/>
                                <a class="btn btn-outline btn-danger" href="http://www.tfca.gob.mx/" style='width: 100%;' target="_blank">Tribunal Federal de Conciliación y Arbitraje</a><br/>
                                <a class="btn btn-outline btn-primary" href="http://www.tfjfa.gob.mx/" style='width: 100%;' target="_blank">Tribunal Federal de Justicia Fiscal y Administrativa</a><br/>
                            </div>
                        </div>
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
        <div class="modal inmodal fade" id="modalContingentes" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width: 80%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                        <h5 class="modal-title">Asuntos Contingentes</h5>
                    </div>
                    <div class="modal-body">
                        <div id="divContingentes" class="row">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
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
        <style>
            body.modal-open .datepicker {
            z-index: 100000 !important;
            }

            .popover.clockpicker-popover{
            z-index: 999999 !important;
            }
        </style>
        <script>
            //Flot Pie Chart

            $(function() {

            var plotObj;

            $.getJSON("/sicj/dashboard/getAsuntosActuales",
            {materia: "1"},
            function(data) {
            var datos = eval(data);
            mostrarLegends(datos,'asuntosActualesLaboralLegends');
            setDatos('asuntosActualesLaboralChart',datos);
            });

            $.getJSON("/sicj/dashboard/getAsuntosContingencia",
            {materia: "1"},
            function(data) {
            var datos = eval(data);
            mostrarLegends(datos,'contingenciaLaboralLegends');
            setDatos('contingenciaLaboralChart',datos);
            });

            $.getJSON("/sicj/dashboard/getAsuntosActuales",
            {materia: "2"},
            function(data) {
            var datos = eval(data);
            mostrarLegends(datos,'asuntosActualesCivilLegends');
            setDatos('asuntosActualesCivilChart',datos);
            });

            $.getJSON("/sicj/dashboard/getAsuntosContingencia",
            {materia: "2"},
            function(data) {
            var datos = eval(data);
            mostrarLegends(datos,'contingenciaCivilLegends');
            setDatos('contingenciaCivilChart',datos);
            });

            $.getJSON("/sicj/dashboard/getAsuntosActuales",
            {materia: "3"},
            function(data) {
            var datos = eval(data);
            mostrarLegends(datos,'asuntosActualesPenalLegends');
            setDatos('asuntosActualesPenalChart',datos);
            });

            $.getJSON("/sicj/dashboard/getAsuntosContingencia",
            {materia: "3"},
            function(data) {
            var datos = eval(data);
            mostrarLegends(datos,'contingenciaPenalLegends');
            setDatos('contingenciaPenalChart',datos);
            });

            });

        </script>
        <script>
            function setDatos(chartDiv,datos){
            var myElem = document.getElementById(chartDiv);
            if (myElem === null){
            console.log('El Div no existe:' + chartDiv);
            } else {
            $.plot($("#"+chartDiv), datos, {
            series: {
            pie: {
            show: true,
            radius: 1,
            label: {
            show: false,
            }
            }
            },
            legend: {
            show: false
            },
            grid: {
            hoverable: true
            },
            tooltip: true,
            tooltipOpts: {
            content: "%p.0%, %s", // show percentages, rounding to 2 decimal places
            shifts: {
            x: 20,
            y: 0
            },
            defaultTheme: true
            }
            });
            }
            }

            function mostrarLegends(data, division){
            var html="";
            html += "<table class='table table-stripped small m-t-md'>";
            html += "<tbody>";
            var total = 0;
            for (var x = 0; x < data.length; x++) {
            html += "<tr><td class='no-borders'><i class='fa fa-circle' style='color:" + data[x].color + ";'></i></td>";
            html += "<td  class='no-borders'> " + data[x].label + " <strong>(" + data[x].data + ")</strong></td> </tr>";
            total += data[x].data;
            }
            html += "</tbody></table>";
            html += "<h5>Total de Juicios: <strong>" + total + "</string></h5>";
            $('#'+division).html(html);
            }

            function obtenerJuiciosContingentes(materiaId){
            jQuery.ajax({
            type:'POST',
            data:'materiaId=' + materiaId,
            url:'/sicj/dashboard/obtenerJuiciosContingentes',
            success:function(data,textStatus){
            $('#divContingentes').html(data);
            $('.dataTables').DataTable( {
            dom: 'Bfrtip',
            lengthMenu: [
            [ 10, 25, 50, -1 ],
            [ '10 registros', '25 registros', '50 registros', 'Mostrar todo' ]
            ],
            buttons: [
            {
            extend: 'pageLength'
            },
            {
            extend: 'csvHtml5',
            title: 'reporteCsv'
            },
            {
            extend: 'excelHtml5',
            title: 'reporteExcel'
            },
            {
            extend: 'pdfHtml5',
            title: 'reportePdf',
            orientation: 'landscape',
            pageSize: 'LETTER'
            }
            ]
            } );
            mostrarModal('modalContingentes');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
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
            daysOfWeekDisabled: [0, 6],
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
        </script>
    </body>
</html>