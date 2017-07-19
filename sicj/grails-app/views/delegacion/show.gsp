<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegación')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Delegaciones</a>
                    </li>
                    <li class="active">
                        <strong>Datos de la Delegación</strong>
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
                            <h5>Datos de la Delegación</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:if test="${flash.error}">
                                <div class="alert alert-danger alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.error}
                                </div>
                            </g:if>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Id</th>
                                            <th>Delegación</th>
                                            <th>Gerente Jurídico</th>
                                            <th>División</th>
                                            <th>Opciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>${delegacion?.id}</td>
                                            <td>${delegacion?.nombre}</td>
                                            <td><g:if test="${gerenteJuridico}">${gerenteJuridico?.nombre + " " + gerenteJuridico?.apellidoPaterno + " " + gerenteJuridico?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else></td>
                                            <td>${delegacion?.division}</td>
                                            <td>
                                                <g:form resource="${this.delegacion}" method="DELETE">
                                                    <g:link action='index' class="btn btn-xs btn-warning">Regresar</g:link>
                                                    <g:link action='edit' id='${delegacion.id}' class="btn btn-primary btn-xs">Editar</g:link>
                                                </g:form>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-6">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Despachos de la Delegación</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th align="center">Nombre del Despacho</th>
                                        <th align="center">Responsable</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in='${despachosDelegacion}' status='i' var='despacho'>
                                        <tr data-value="${despacho?.id}" class="gradeX" onclick="${remoteFunction(controller : 'despacho', action : 'obtenerUsuariosDespacho', params : '\'despacho=\' + escape($(this).data(\'value\'))', onSuccess : 'actualizar(data, \'usuarios\')')}">
                                            <td>${despacho?.nombre}</td>
                                            <td>${despacho?.getResponsable(despacho?.id)}</td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Usuarios Adscritos al Despacho</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <table id="usuariosDelDespacho" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th align="center">Nombre</th>
                                        <th align="center">Activo</th>
                                        <th align="center">Bloqueado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr><td colspan="3"> Seleccione el Despacho deseado para ver los usuarios adscritos al mismo</td></tr>
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Usuarios Adscritos a la Delegación</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" >
                                    <thead>
                                        <tr>
                                            <th align="center">Nombre del Usuario</th>
                                            <th align="center">Activo</th>
                                            <th align="center">Bloqueado</th>
                                            <th align="center">Fecha de Alta</th>
                                            <th align="center">Fecha de Baja</th>
                                            <th align="center">Bloquear</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr><th colspan="6" style="text-align: center;"><strong>Usuarios Activos</strong></th></tr>
                                                <g:each in='${usuariosDelegacionList.findAll{ it.enabled == true}}' status='i' var='usuario'>
                                                <tr class="gradeX">
                                                    <td>${usuario?.nombre + " " + usuario?.apellidoPaterno + " " + usuario?.apellidoMaterno} </td>
                                                    <td align="center"><g:if test='${usuario.enabled}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                    <td align="center"><g:if test='${usuario?.accountLocked}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                    <td>${usuario?.fechaDeRegistro}</td>
                                                    <td>${usuario?.fechaDeBloqueo}</td>
                                                    <td>
                                                        <g:if test="${usuario?.enabled}">
                                                            <g:link controller='user' action='bloquearUsuario' params="[id: usuario.id, delegacion: delegacion.id]" class="btn btn-xs btn-danger">Bloquear</g:link>
                                                        </g:if>
                                                    </td>
                                                </tr>
                                        </g:each>
                                        <tr><th colspan="6" style="text-align: center;"><strong>Usuarios Bloqueados</strong></th></tr>
                                                <g:each in='${usuariosDelegacionList.findAll{ it.enabled == false}}' status='i' var='usuario'>
                                                <tr class="gradeX">
                                                    <td>${usuario?.nombre + " " + usuario?.apellidoPaterno + " " + usuario?.apellidoMaterno} </td>
                                                    <td align="center"><g:if test='${usuario.enabled}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                    <td align="center"><g:if test='${usuario?.accountLocked}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                    <td>${usuario?.fechaDeRegistro}</td>
                                                    <td>${usuario?.fechaDeBloqueo}</td>
                                                    <td>
                                                        <g:if test="${usuario?.enabled}">
                                                            <g:link controller='user' action='bloquearUsuario' params="[id: usuario.id, delegacion: delegacion.id]" class="btn btn-xs btn-danger">Bloquear</g:link>
                                                        </g:if>
                                                    </td>
                                                </tr>
                                        </g:each>
                                        <g:if test="${(usuariosDelegacionList.findAll{ it.enabled == false} == null) || (usuariosDelegacionList.findAll{ it.enabled == false})?.size() == 0}">
                                            <tr class="gradeX"><td colspan="6" style="text-align: center;">No hay usuario bloqueados</td></tr>
                                        </g:if>
                                    </tbody>
                                </table>
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
            for (var x = 0; x < resultado.length; x++) {          
            html += "<tr><td>"+resultado[x].nombre+" " + resultado[x].apellidoPaterno + " "+resultado[x].apellidoMaterno+"</td>";
            html += "<td align='center'>";
            if(resultado[x].enabled == true){
            html += "<i class='fa fa-check text-navy'></i>";
            }
            html += "</td><td align='center'>";
            if(resultado[x].accountLocked == true){
            html += "<i class='fa fa-check text-navy'></i>";
            }
            html += "</td>/tr>"; 
            }
            $('#usuariosDelDespacho tbody').html(html);
            }
        </script>
    </body>
</html>
