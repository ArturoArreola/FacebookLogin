<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegación')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
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
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Usuarios</a>
                    </li>
                    <li class="active">
                        <strong>Reporte de Actividad</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuAdmin"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Reporte de Actividad</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <form id="reportesForm" method="POST" class="form-horizontal">
                                        <fieldset>
                                            <div class="row">
                                                <label class="col-md-offset-4 col-md-1 control-label">Elija el criterio de búsqueda </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <g:select noSelection="['0':'TODOS']" class="chosen-select" style="width:300px;" tabindex="2" name="seleccionCriterio" id="seleccionCriterio" from="${[[id:1, name:'Por Usuario'],[id:2, name:'Por Delegación'],[id:3, name:'Por Despacho']]}" optionKey="id" optionValue="name" onchange="mostrarOpciones(escape(this.value));"/>
                                                    </div>
                                                </div>
                                            </div>
                                            <br/>
                                            <div class="row">
                                                <div class="row opcionFiltro" id="usuarioDiv" style="display: none;">
                                                    <label class="col-md-offset-4  col-md-1 control-label">Usuario </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group" id='usuarioRemote'>
                                                            <input id="usuario" style="width:300px;" name='usuario' type="text" placeholder="Buscar usuario..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >
                                                            <input type="hidden" id="idUsuario" name="idUsuario">
                                                        </div>
                                                    </div>
                                                </div>
                                                <br/>
                                                <div class="row opcionFiltro" id="delegacionDiv" style="display: none;">
                                                    <label class="col-md-offset-4  col-md-1 control-label">Delegación </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <g:select noSelection="['0':'TODAS LAS DELEGACIONES']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion.findAll('from Delegacion d Order by d.nombre')}" optionKey="id" onchange="${remoteFunction(controller : 'despacho', action : 'obtenerDespachos', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizar(data, \'despacho\')')}"/>
                                                        </div>
                                                    </div>
                                                </div>
                                                <br/>
                                                <div class="row opcionFiltro" id="despachoDiv" style="display: none;">
                                                    <label class="col-md-offset-4  col-md-1 control-label">Despacho </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <select class="chosen-select" id="despacho" name="despacho.id" data-placeholder="TODOS LOS DESPACHOS" style="width:300px;" tabindex="2" >
                                                            </select>     
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <br/>
                                            <center>
                                                <div class="alert alert-warning">
                                                    Es importante que tenga en cuenta que mientras más general sea el reporte que quiera obtener, más tiempo será requerido para la generación del mismo.
                                                </div>
                                            </center>
                                            <div class="row text-center col-md-offset-3 col-md-6">
                                                <div class="form-group" id="data_5">
                                                    <label class="col-md-3 control-label">Rango de Fechas * </label>
                                                    <div class="col-md-8 input-daterange input-group" id="datepicker">
                                                        <input type="text" class="input-sm form-control" name="fechaInicial" />
                                                        <span class="input-group-addon"> a </span>
                                                        <input type="text" class="input-sm form-control" name="fechaFinal" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-md-12 text-center">
                                                        <g:link class="btn btn-warning" action="search">Regresar</g:link>
                                                            <button type="button" class="btn btn-success" onclick="obtenerReporte();"><i class="fa fa-gears"></i> Ejecutar Consulta</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </fieldset>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="resultadoReporte"></div>
            </div>
            <script type="text/javascript">
            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
            html += "<option value='0'>Seleccione un despacho</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
            }
            $('#'+tipo).html(html);
            $('#'+tipo).trigger("chosen:updated");
            } 
            function mostrarOpciones(opcion){
            $('.opcionFiltro').fadeOut();
            $('#idUsuario').val("");
            $('#usuarioRemote .typeahead').typeahead('val', "");
            if(opcion === "1"){
            $('#usuarioDiv').fadeIn();
            } else if (opcion === "2"){
            $('#delegacionDiv').fadeIn();
            } else if (opcion === "3"){
            $('#delegacionDiv').fadeIn();
            $('#despachoDiv').fadeIn();
            }
            }

            function obtenerReporte(){
            $.ajax({
            type: 'POST',
            data: $('#reportesForm').serialize(),
            url: '/sicj/user/obtenerReporteDeAccesos',
            success: function (data, textStatus) {
            $('#resultadoReporte').html(data);
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
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            sweetAlert("Oops...", "Algo salió mal, intenta nuevamente en unos minutos.", "error");
            }
            });
            }

            function setearUsuario(idPersona){
            var idUsuario = eval(idPersona);
            $('#idUsuario').val(idUsuario.id);
            }

            $(document).ready(function(){
            var bestPictures = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: '/sicj/user/searchByNombre',
            remote: {
            url: '/sicj/user/searchByNombre?query=%QUERY',
            wildcard: '%QUERY'
            }
            });
            $('#usuarioRemote .typeahead').typeahead({minLength: 3}, {
            name: 'usuario',
            display: 'value',
            source: bestPictures,
            templates: {
            empty: [
            '<div class="empty-message">',
            'No existen coincidencias. Por favor registre al usuario en el apartado correspondiente.',
            '</div>'
            ].join('\n')
            }
            });
            $('#usuarioRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
            setearUsuario(suggestion);
            });

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
            border-radius: 8px;
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
            border-radius: 8px;
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