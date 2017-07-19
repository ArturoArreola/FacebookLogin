<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegación')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
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
                        <strong>Reporte General</strong>
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
                            <h5>Reporte General</h5>
                        </div>
                        <div class="ibox-content">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover dataTables" style="overflow-x: auto;">
                                    <thead>
                                        <tr>
                                            <th>Usuario</th>
                                            <th>Activo</th>
                                            <th>Delegación</th>
                                            <th>Despacho/Proveedor</th>
                                            <g:each in="${perfiles}" var="perfil" status="i">
                                                <th>${perfil.name}</th>
                                            </g:each>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in="${listaDeUsuarios}" var="usuarioPerfil" status="u">
                                            <tr>
                                                <td>${usuarioPerfil.usuario.toString()}</td>
                                                <g:set var="usuarioActivo" value="${usuarioPerfil.usuario.enabled}" />
                                                <g:if test="${usuarioActivo.toBoolean()}">
                                                    <td style="text-align: center;" class="text-navy"><strong>SI</strong></td>
                                                </g:if>
                                                <g:else>
                                                    <td style="text-align: center;" class="text-danger"><strong>NO</strong></td>
                                                </g:else>
                                                <td>${usuarioPerfil.usuario.delegacion.nombre}</td>
                                                <td>${usuarioPerfil.usuario.despacho ?: usuarioPerfil.usuario.proveedor}</td>
                                                <g:each in="${perfiles}" var="perfil" status="p">
                                                    <g:if test="${usuarioPerfil.perfiles.contains(perfil)}">
                                                        <td style="text-align: center;" class="text-navy"><strong>X</strong></td>
                                                        </g:if>
                                                        <g:else>
                                                        <td></td>
                                                    </g:else>
                                                </g:each>
                                            </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <div class="col-md-12 text-center">
                                        <g:link class="btn btn-warning" action="search">Regresar</g:link>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <script>
            $(document).ready(function() {
            $('.dataTables').DataTable( {
            dom: 'Bfrtip',
            buttons: [
                        {
                extend: 'csvHtml5',
                title: 'reporteGeneralCsv'
            },
            {
                extend: 'excelHtml5',
                title: 'reporteGeneralExcel'
            },
                        {
                extend: 'pdfHtml5',
                title: 'reporteGeneralPdf',
                orientation: 'landscape',
                pageSize: 'LEGAL'
            }
            ]
            } );
            } );
        </script>
    </body>
</html>