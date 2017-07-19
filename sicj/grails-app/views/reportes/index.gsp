<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'juicio.label', default: 'Juicio')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Reportes</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/reportes/index">Reportes</a>
                    </li>
                    <li class="active">
                        <strong>Generación de Reportes </strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <div class="row">
                <div id="divBusqueda" class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Generación de Reportes</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.error}">
                                <center>
                                    <div class="alert alert-danger alert-dismissable">
                                        <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                        ${flash.error}
                                    </div>
                                </center>
                            </g:if> 
                            <div class="row">
                                <div class="col-lg-12">
                                    <g:form id="reportesForm" name="reportesForm" method="POST" action="generarReporte" class="form-horizontal">
                                        <fieldset>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-1 control-label">Materia </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <select data-placeholder="Elija una Materia..." class="chosen-select" style="width: 300px; display: none;" tabindex="-1" name="materia.id" id="materia" onchange="verificarMateria(escape(this.value));">
                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR'>
                                                                    <option value="0">TODAS LAS MATERIAS</option>
                                                                </sec:ifAnyGranted>
                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_CIVIL,ROLE_CONSULTA_JUICIO_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_CIVIL,ROLE_CONSULTA_HISTORICO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_NACIONAL'>
                                                                    <option value="2">CIVIL / MERCANTIL</option>
                                                                </sec:ifAnyGranted>
                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_LABORAL,ROLE_CONSULTA_JUICIO_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_LABORAL,ROLE_CONSULTA_HISTORICO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_NACIONAL'>
                                                                    <option value="1">LABORAL</option>
                                                                </sec:ifAnyGranted>
                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_PENAL,ROLE_CONSULTA_JUICIO_PENAL,ROLE_CONSULTA_JUICIO_NACIONAL_PENAL,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_PENAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_PENAL_NACIONAL,ROLE_CONSULTA_HISTORICO_PENAL,ROLE_CONSULTA_HISTORICO_PENAL_NACIONAL,ROLE_CONSULTA_HISTORICO_NACIONAL'>
                                                                    <option value="3">PENAL</option>
                                                                </sec:ifAnyGranted>
                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_REZAGO_HISTORICO,ROLE_REZAGO_HISTORICO_NACIONAL'>
                                                                    <option value="4">REZAGO HISTÓRICO</option>
                                                                </sec:ifAnyGranted>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <label class="col-md-1 control-label">Delegación </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_REPORTE_POR_MATERIA_NACIONAL'>  
                                                                <g:select noSelection="['0':'TODAS LAS DELEGACIONES']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion.findAll('from Delegacion d Where d.id > 0 order by d.nombre')}" optionKey="id" onchange = "${remoteFunction(controller : 'despacho', action : 'obtenerDespachos', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizar(data, \'despacho\')')}"/>
                                                            </sec:ifAnyGranted>
                                                            <sec:ifNotGranted roles='ROLE_ADMIN,ROLE_REPORTE_POR_MATERIA_NACIONAL'>
                                                                <sec:ifAnyGranted roles='ROLE_REPORTE_POR_MATERIA'>
                                                                    <g:select class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${[usuario.delegacion]}" value="${usuario.delegacion.id}" optionKey="id" onchange = "${remoteFunction(controller : 'despacho', action : 'obtenerDespachos', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizar(data, \'despacho\')')}"/>
                                                                </sec:ifAnyGranted>
                                                            </sec:ifNotGranted>
                                                        </div>
                                                    </div>
                                                        <div class="row">
                                                            <label class="col-md-1 control-label">Despacho </label>
                                                            <div class="col-md-3">
                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_REPORTE_POR_MATERIA_NACIONAL'>
                                                                    <select class="chosen-select" id="despacho" name="despacho.id" data-placeholder="Elija una opción" style="width:300px;" tabindex="2" >
                                                                    </select>
                                                                </sec:ifAnyGranted>
                                                                <sec:ifNotGranted roles='ROLE_ADMIN,ROLE_REPORTE_POR_MATERIA_NACIONAL'>
                                                                    <sec:ifAnyGranted roles='ROLE_REPORTE_POR_MATERIA'>
                                                                        <g:if test="${usuario.tipoDeUsuario == 'INTERNO'}">
                                                                            <g:select noSelection="['0':'TODOS LOS DESPACHOS']" class="chosen-select" style="width:300px;" tabindex="2" name="despacho.id" id="despacho" from="${mx.gox.infonavit.sicj.admin.Despacho.findAll('from Despacho d Where d.id > 0 and d.delegacion.id = ' + usuario.delegacion.id + ' order by d.nombre')}" optionKey="id" />
                                                                        </g:if>
                                                                        <g:else>
                                                                            <g:select class="chosen-select" style="width:300px;" tabindex="2" name="despacho.id" id="despacho" from="${[usuario.despacho]}" value="${usuario.despacho.id}" optionKey="id" onchange = "${remoteFunction(controller : 'despacho', action : 'obtenerDespachos', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizar(data, \'despacho\')')}"/> 
                                                                        </g:else>
                                                                    </sec:ifAnyGranted>
                                                            </sec:ifNotGranted>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row col-md-4 col-md-offset-1" id="divNssSeparado" style="display: none;">
                                                        <div class="input-group col-md-12">
                                                            <div class="row">
                                                                <div class="checkbox checkbox-success checkbox-circle col-md-12">
                                                                    <input type="checkbox" id="nssSeparado" name="nssSeparado" value="false"/>
                                                                    <label class="col-md-3" for='nssSeparado'><strong>NSS Separado</strong></label>
                                                                </div>
                                                            </div>
                                                        </div>  
                                                    </div>    
                                                    <input type="hidden" name="reporteSolicitado" id="reporteSolicitado" value="0">
                                                </div>
                                            </fieldset>
                                            <div class="tabs-container">
                                                <ul class="nav nav-tabs">
                                                    <li class="active"><a data-toggle="tab" href="#tab-1"> Reportes Disponibles</a></li>
                                                    <li class=""><a data-toggle="tab" href="#tab-2">Reportes Personalizados</a></li>
                                                </ul>
                                                <div class="tab-content">
                                                    <div id="tab-1" class="tab-pane active">
                                                        <div class="panel-body">
                                                            <div class="row text-center">
                                                                <button type="button" onclick="generarReporte(1);" class="btn btn-info">Reporte General</button>
                                                                <button type="button" onclick="generarReporte(2);" class="btn btn-primary">Reporte Juicios en Archivo Definitivo</button>
                                                                <button type="button" onclick="generarReporte(3);" class="btn btn-danger">Reporte Juicios Cancelados</button>
                                                            </div>
                                                            <sec:ifAnyGranted roles='ROLE_ADMIN'>  
                                                                <div class="row text-center">
                                                                    <button type="button" onclick="generarReporte(4);" class="btn btn-warning">Transferencia Delegación/Despacho</button>
                                                                    <button type="button" onclick="generarReporte(5);" class="btn btn-warning">Transferencia Despacho/Despacho</button>
                                                                </div>
                                                            </sec:ifAnyGranted>
                                                        </div>
                                                    </div>
                                                    <div id="tab-2" class="tab-pane">
                                                        <div class="panel-body">
                                                            <center>
                                                                <div class="alert alert-warning">
                                                                    Es importante que tenga en cuenta que mientras más general sea el reporte que quiera obtener, más tiempo será requerido para la generación del mismo.
                                                                </div>
                                                            </center>
                                                            <div class="row">
                                                                <div class="form-group col-md-12" id="data_5">
                                                                    <label class="col-md-2 control-label">Rango de Fechas * </label>
                                                                    <div class="col-md-9 input-daterange input-group" id="datepicker">
                                                                        <input type="text" class="input-sm form-control" readOnly name="fechaInicial" style="background: white;" placeholder="dd/mm/aaaa"/>
                                                                        <span class="input-group-addon"> a </span>
                                                                        <input type="text" class="input-sm form-control" readOnly name="fechaFinal" style="background: white;" placeholder="dd/mm/aaaa"/>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="row">
                                                                    <label class="col-md-2 control-label">Ambito </label>
                                                                    <div class="col-md-3">
                                                                        <div class="input-group">
                                                                            <g:select noSelection="['':'Elija el ambito...']" data-placeholder="Elija el ambito..." class="chosen-select" style="width:300px;" tabindex="2" name="ambito.id" id="ambito" from="${mx.gox.infonavit.sicj.catalogos.Ambito?.list(sort:'nombre')}" optionKey="id" onchange = "var materia = document.getElementById('materia').value; ${remoteFunction(controller : 'juicio', action : 'obtenerTiposDeProcedimiento', params : '\'ambito=\' + escape(this.value) + \'&materia=\' + materia', onSuccess : 'actualizar(data, \'tipoDeProcedimiento\')')}" />
                                                                        </div>
                                                                    </div>
                                                                    <label class="col-md-2 control-label">Tipo de Juicio </label>
                                                                    <div class="col-md-3">
                                                                        <div class="input-group">
                                                                            <select class="chosen-select" id="tipoDeProcedimiento" name="tipoDeProcedimiento.id" data-placeholder="Elija primero el ambito..." style="width:300px;" tabindex="2" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerEtapasProcesales', params : '\'tipoDeProcedimiento=\' + escape(this.value)', onSuccess : 'actualizar(data, \'etapaProcesal\')')}">
                                                                            </select>    
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="row">
                                                                    <label class="col-md-2 control-label">Etapa Procesal </label>
                                                                    <div class="col-md-3">
                                                                        <div class="input-group">
                                                                            <select class="chosen-select" id="etapaProcesal" name="etapaProcesal.id" data-placeholder="Elija primero el tipo de procedimiento..." style="width:300px;" tabindex="2" >
                                                                            </select>    
                                                                        </div>
                                                                    </div>
                                                                    <label class="col-md-2 control-label">Estado del Juicio </label>
                                                                    <div class="col-md-3">
                                                                        <div class="input-group">
                                                                            <select data-placeholder="Elija el Estado..." class="chosen-select" style="width: 300px; display: none;" tabindex="-1" name="estadoDeJuicio.id" id="estadoDeJuicio">
                                                                                <option value="">Elija el Estado ...</option>
                                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_PENAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_PENAL_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_NACIONAL'>
                                                                                    <option value="6">ARCHIVO DEFINITIVO</option>
                                                                                </sec:ifAnyGranted>
                                                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_CONSULTA_HISTORICO_LABORAL,ROLE_CONSULTA_HISTORICO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_CIVIL,ROLE_CONSULTA_HISTORICO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_PENAL,ROLE_CONSULTA_HISTORICO_PENAL_NACIONAL,ROLE_CONSULTA_HISTORICO_NACIONAL'>
                                                                                    <option value="7">ARCHIVO HISTORICO</option>
                                                                                </sec:ifAnyGranted>
                                                                                <option value="4">CANCELADO POR ERROR</option>
                                                                                <option value="1">EN PROCESO</option>
                                                                                <option value="2">TERMINADO</option>
                                                                                <option value="5">WORK FLOW TERMINADO</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="hr-line-dashed"></div>
                                                            <div class="form-group">
                                                                <div class="col-sm-4 col-sm-offset-2">
                                                                    <button class="btn btn-warning" type="reset" onclick="limpiarFormulario();">Limpiar</button>
                                                                    <button type="submit" class="btn btn-primary">Generar Reporte</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                    </g:form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
            html += "<option value='0'>Elija una opción...</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
            }
            $('#'+tipo).html(html);
            $('#'+tipo).trigger("chosen:updated");
            }

            function limpiarFormulario(){
            $('#reportesForm').get(0).reset();
            $('#reportesForm .chosen-select').trigger("chosen:updated");
            $('#reporteSolicitado').val(0);
            $('#nssSeparado').val(false);
            $('#divNssSeparado').hide("slow");
            }

            function generarReporte(tipo){
            $('#reporteSolicitado').val(tipo);
            $( "#reportesForm" ).submit();
            limpiarFormulario();
            }

            function verificarMateria(materia){
            if(materia === "1"){
            $('#nssSeparado').val(true);
            $('#divNssSeparado').show("slow");
            } else {
            $('#nssSeparado').val(false);
            $('#divNssSeparado').hide("slow");
            }
            }
        </script>
        <script>
            $(document).ready(function(){
            $('#data_5 .input-daterange').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            todayHighlight: true,
            autoclose: true
            });
            });
        </script>
        <style type="text/css">
            .typeahead, .tt-query, .tt-hint {
            border: 1px solid #CCCCCC;
            /*border-radius: 8px;*/
            line-height: 15px;
            outline: medium none;
            padding: 8px 12px;
            width: 300px;
            }
            .typeahead {
            background-color: #FFFFFF;
            }
            .typeahead:focus {
            border: 2px solid #0097CF;
            }
            .tt-query {
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
            }
            .tt-hint {
            color: #999999;
            }
            .tt-menu {
            background-color: #FFFFFF;
            border: 1px solid rgba(0, 0, 0, 0.2);
            /*border-radius: 8px;*/
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            margin-top: 12px;
            padding: 8px 0;
            width: 300px;
            }
            .tt-suggestion {
            line-height: 24px;
            padding: 3px 20px;
            }
            .tt-suggestion.tt-is-under-cursor {
            background-color: #0097CF;
            color: #FFFFFF;
            }
            .tt-suggestion p {
            margin: 0;
            }
        </style>
    </body>
</html>
