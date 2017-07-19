<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'juicio.label', default: 'Juicio')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
                            <!-- Data Tables -->
        <g:external dir="assets/plugins/dataTables" file="dataTables.bootstrap.css" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.responsive.css" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.tableTools.min.css" />
        <g:external dir="assets/plugins/dataTables" file="buttons.dataTables.min.css" />
        <g:external dir="assets/plugins/dataTables/latest" file="jquery.dataTables.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="dataTables.buttons.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="buttons.flash.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="jszip.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="pdfmake.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="vfs_fonts.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="buttons.html5.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="buttons.print.min.js" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.bootstrap.js" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.responsive.js" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.tableTools.min.js" />
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Control de Juicios</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/juicio/search">Juicios</a>
                    </li>
                    <li class="active">
                        <strong>Buscar Asuntos </strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuJuicios"/>
            <div class="row">
                <div id="divBusqueda" class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Búsqueda de Juicio</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:form id="busquedaAvanzadaForm" name="busquedaAvanzadaForm" class="form-horizontal">
                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-md-2 control-label">Materia * </label>
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <select data-placeholder="Elija una Materia..." class="chosen-select" style="width: 300px; display: none;" tabindex="-1" name="materia.id" id="materia" onchange="cambiarEtiquetas(this.value);">
                                                    <option value="">Elija una Materia...</option>
                                                    <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_LABORAL,ROLE_CONSULTA_JUICIO_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_LABORAL,ROLE_CONSULTA_HISTORICO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_NACIONAL'>
                                                        <option value="1">LABORAL</option>
                                                    </sec:ifAnyGranted>
                                                    <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_AUDITOR,ROLE_CIVIL,ROLE_CONSULTA_JUICIO_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_CIVIL,ROLE_CONSULTA_HISTORICO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_NACIONAL'>
                                                        <option value="2">CIVIL / MERCANTIL</option>
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
                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-md-2 control-label">Delegación </label>
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_ALTA_LABORAL_NACIONAL,ROLE_ALTA_CIVIL_NACIONAL,ROLE_ALTA_PENAL_NACIONAL,ROLE_CONSULTA_AUDITOR,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_JUICIO_NACIONAL_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL_PENAL,ROLE_CONSULTA_JUICIO_NACIONAL'>
                                                    <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion.findAll('from Delegacion d Where d.id > 0 order by d.nombre')}" optionKey="id" onchange = "${remoteFunction(controller : 'despacho', action : 'obtenerDespachos', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizar(data, \'despacho\')')}"/>
                                                    </sec:ifAnyGranted>
                                                    <sec:ifNotGranted roles='ROLE_ADMIN,ROLE_ALTA_LABORAL_NACIONAL,ROLE_ALTA_CIVIL_NACIONAL,ROLE_ALTA_PENAL_NACIONAL,ROLE_CONSULTA_AUDITOR,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_JUICIO_NACIONAL_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL_PENAL,ROLE_CONSULTA_JUICIO_NACIONAL'>
                                                        <sec:ifAnyGranted roles='ROLE_ALTA_LABORAL,ROLE_ALTA_CIVIL,ROLE_ALTA_PENAL,ROLE_CONSULTA_JUICIO_LABORAL,ROLE_CONSULTA_JUICIO_CIVIL,ROLE_CONSULTA_JUICIO_PENAL'>  
                                                        <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${[usuario.delegacion]}" value="${usuario.delegacion.id}" optionKey="id" onchange = "${remoteFunction(controller : 'despacho', action : 'obtenerDespachos', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizar(data, \'despacho\')')}"/>
                                                        </sec:ifAnyGranted>
                                                    </sec:ifNotGranted>
                                                </div>
                                            </div>
                                            <label class="col-md-2 control-label">Ambito </label>
                                            <div class="col-md-3">
                                                <div class="input-group">
                                                    <g:select noSelection="['':'Elija el ambito...']" data-placeholder="Elija el ambito..." class="chosen-select" style="width:300px;" tabindex="2" name="ambito.id" id="ambito" from="${mx.gox.infonavit.sicj.catalogos.Ambito?.list(sort:'nombre')}" optionKey="id" onchange = "var materia = document.getElementById('materia').value; ${remoteFunction(controller : 'juicio', action : 'obtenerTiposDeProcedimiento', params : '\'ambito=\' + escape(this.value) + \'&materia=\' + materia', onSuccess : 'actualizar(data, \'tipoDeProcedimiento\')')}" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <label class="col-md-2 control-label">Expediente Interno </label>
                                            <div class="col-md-3">
                                                <input id="expedienteInterno" placeholder="AA-11-11111" name="expedienteInterno" style="text-transform: uppercase" type="text" class="form-control" maxlength="11" onBlur="this.value=this.value.toUpperCase();">
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
                                            <label class="col-md-2 control-label">Expediente de Juicio </label>
                                            <div class="col-md-3">
                                                <input id="expediente" name="expediente" style="text-transform: uppercase" type="text" class="form-control" maxlength="11" onBlur="this.value=this.value.toUpperCase();">
                                            </div>
                                            <label class="col-md-2 control-label">Etapa Procesal </label>
                                            <div class="col-md-3">
                                                <div class="input-group">
                                                    <select class="chosen-select" id="etapaProcesal" name="etapaProcesal.id" data-placeholder="Elija primero el tipo de procedimiento..." style="width:300px;" tabindex="2" >
                                                    </select>    
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row" id='actorRemote'>
                                            <label id="labelActor" class="col-md-2 control-label">Actor </label>
                                            <div class="col-md-3">
                                                <input type="hidden" name="idActor" id="idActor">
                                                <input id="actor" style="width:295px;" name='actor' type="text" placeholder="Buscar actor..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >
                                            </div>
                                            <label class="col-md-2 control-label">Despacho </label>
                                            <div class="col-md-3">
                                                <g:if test="${usuario.tipoDeUsuario == 'INTERNO'}">
                                                    <select class="chosen-select" id="despacho" name="despacho.id" data-placeholder="Elija primero la Delegación..." style="width:300px;" tabindex="2">
                                                    </select>
                                                </g:if>
                                                <g:elseif test="${usuario.tipoDeUsuario == 'EXTERNO'}">
                                                    <g:select noSelection="['':'Elija primero la Delegación...']" data-placeholder="Elija primero la Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="despacho.id" id="despacho" from="${[usuario.despacho]}" value="${usuario.despacho.id}" optionKey="id" />
                                                </g:elseif>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row" id='demandadoRemote'>
                                            <label id="labelDemandado" class="col-md-2 control-label">Demandado </label>
                                            <div class="col-md-3">
                                                <input type="hidden" name="idDemandado" id="idDemandado">
                                                <input id="demandado" style="width:295px;" name='demandado' type="text" placeholder="Buscar demandado..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >
                                            </div>
                                            <% def anioActual = Calendar.getInstance().get(Calendar.YEAR) %>
                                            <label id="labelAnio" class="col-md-2 control-label">Año </label>
                                            <div class="col-md-3">
                                                <g:select id="anio" name="anio" noSelection="['0':':: Sin año ::']" class="chosen-select" style="width:300px;" tabindex="2" from="${(anioActual)..(anioActual-15)}" value="${anioActual}"/></div>
                                        </div>
                                    </div>
                                    <div class="hr-line-dashed"></div>
                                    <div class="form-group">
                                        <div class="col-sm-4 col-sm-offset-2">
                                            <button class="btn btn-white" type="submit">Cancelar</button>
                                            <button class="btn btn-warning" type="reset" onclick="limpiarFormulario();$('#resultados').html('');">Limpiar</button>
                                            <g:submitToRemote onSuccess="ocultarFormulario()" onFailure="alert('algo fallo');" onComplete="ocultarModal('spinnerModal')" before="mostrarModal('spinnerModal')" class="btn btn-primary" url="[controller: 'juicio',action: 'doSearch']" update="resultados" method="POST" value="Buscar"/>
                                        </div>
                                    </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
            <div id="resultados" class="row">
            </div>
            <div class="modal inmodal fade" id="modalLista" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                            <h5 class="modal-title">Lista Completa</h5>
                        </div>
                        <div class="modal-body">
                            <div id="divListaDePersonas"></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
            html += "<option value=''>Elija una opción...</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
            }
            $('#'+tipo).html(html);
            $('#'+tipo).trigger("chosen:updated");
            }

            function cambiarEtiquetas(materia){
            if(materia == '3'){
            $('#labelActor').html('Denunciante ');
            $('#labelDemandado').html('Probable Responsable ');
            $("#actor").attr("placeholder", "Buscar denunciante...");
            $("#demandado").attr("placeholder", "Buscar probable responsable...");
            } else {
            $('#labelActor').html('Actor ');
            $('#labelDemandado').html('Demandado ');
            $("#actor").attr("placeholder", "Buscar actor...");
            $("#demandado").attr("placeholder", "Buscar demandado...");
            }
            }

            function limpiarFormulario(){
            $('#labelActor').html('Actor ');
            $('#labelDemandado').html('Demandado ');
            $("#actor").attr("placeholder", "Buscar actor...");
            $("#demandado").attr("placeholder", "Buscar demandado...");
            $('#busquedaAvanzadaForm').get(0).reset();
            $('#busquedaAvanzadaForm .chosen-select').trigger("chosen:updated");
            $('#idActor').val('');
            $('#idDemandado').val('');
            $('#tipoDeProcedimiento').html('');
            $('#tipoDeProcedimiento').trigger("chosen:updated");
            $('#etapaProcesal').html('');
            $('#etapaProcesal').trigger("chosen:updated");
            $('#despacho').html('');
            $('#despacho').trigger("chosen:updated");
            $('#resultadosDeBusqueda').DataTable( {
            dom: 'Bfrtip',
            "pageLength": 30,
            lengthMenu: [
            [ 30, 60, 90, -1 ],
            [ '30 registros', '60 registros', '90 registros', 'Mostrar todo' ]
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
            }

            function ocultarFormulario(){
            limpiarFormulario();
            $('#divBusqueda .ibox-content').fadeOut();
            $('#divBusqueda .fa-chevron-up').addClass("fa-chevron-down");
            $('#divBusqueda .fa-chevron-down').removeClass("fa-chevron-up");
            $('#divBusqueda').removeClass("border-bottom");
            }

            function seleccionarActor(sugerencia, tipoDeParte){
            var actor = eval(sugerencia);
            actor =  actor.id;
            $('#id'+tipoDeParte).val(actor);
            }

            function mostrarDespacho(mensaje){
            swal({title:"<small>Detalles</small>", text: mensaje, html: true});
            }

            function mostrarListaCompleta(idJuicio, lista){
            jQuery.ajax({
            type:'POST',
            data:'idJuicio=' + idJuicio + "&lista=" + lista,
            url:'/sicj/juicio/mostrarListaCompleta',
            success:function(data,textStatus){
            $('#divListaDePersonas').html(data);
            $('#modalLista').modal('show');
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            }
            });
            }

            function mostrarModal(modal){
            $('#'+modal).modal('show');
            }

            function ocultarModal(modal){
            $('#'+modal).modal('hide');
            }

            $(document).ready(function(){
            var bestPictures = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: '/sicj/juicio/buscarActores',
            remote: {
            url: '/sicj/juicio/buscarActores?query=%QUERY',
            wildcard: '%QUERY'
            }
            });
            $('#actorRemote .typeahead').typeahead({minLength: 3}, {
            name: 'actor',
            display: 'value',
            source: bestPictures,
            limit: 25,
            templates: {
            empty: [
            '<div class="empty-message">',
            'No existen coincidencias. Por favor registre al actor dando click en el botón de la izquierda.',
            '</div>'
            ].join('\n')
            }
            });
            $('#actorRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
            seleccionarActor(suggestion,'Actor');
            });
            $('#demandadoRemote .typeahead').typeahead({minLength: 3}, {
            name: 'actor',
            display: 'value',
            source: bestPictures,
            limit: 25,
            templates: {
            empty: [
            '<div class="empty-message">',
            'No existen coincidencias. Por favor registre al demandado dando click en el botón de la izquierda.',
            '</div>'
            ].join('\n')
            }
            });
            $('#demandadoRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
            seleccionarActor(suggestion,'Demandado');
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
