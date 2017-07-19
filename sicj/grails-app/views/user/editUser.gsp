<sec:ifNotSwitched>
    <sec:ifAllGranted roles='${securityConfig.ui.switchUserRoleName}'>
        <g:set var='username' value='${uiPropertiesStrategy.getProperty(user, 'username')}'/>
        <g:if test='${username}'>
            <g:set var='canRunAs' value='${true}'/>
        </g:if>
    </sec:ifAllGranted>
</sec:ifNotSwitched>
<html>
    <head>
        <meta name="layout" content="inspinia"/>
    <s2ui:title messageCode='default.edit.label' entityNameMessageCode='user.label' entityNameDefault='User'/>
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
                    <strong>Editar Usuario </strong> <small>${user?.username}</small>
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
                        <h5>Editar Usuario</h5>
                    </div>
                    <form class="form-horizontal" action="/sicj/user/updateUser" method="post" name="updateForm" id="updateForm">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="tabs-container">
                                    <ul class="nav nav-tabs">
                                        <li class="active"><a data-toggle="tab" href="#tab-6">Datos Generales</a></li>
                                        <li class=""><a data-toggle="tab" href="#tab-7">Perfiles</a></li>
                                        <li class=""><a data-toggle="tab" href="#tab-8">Roles</a></li>
                                    </ul>
                                    <div class="tab-content ">
                                        <div id="tab-6" class="tab-pane active">
                                            <div class="panel-body">
                                                <div class="ibox-content">
                                                    <g:if test="${flash.message}">
                                                        <div class="alert alert-info alert-dismissable">
                                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                                            ${flash.message}
                                                        </div>
                                                    </g:if>
                                                    <g:hasErrors bean="${this.user}">
                                                        <g:eachError bean="${this.user}" var="error">
                                                            <g:if test="${error in org.springframework.validation.FieldError}">
                                                                <div class="alert alert-danger alert-dismissable">
                                                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                                                    <g:message error="${error}"/>
                                                                </div>
                                                            </g:if>
                                                        </g:eachError>
                                                    </g:hasErrors>
                                                    <g:hiddenField name="id" value="${this.user?.id}" />
                                                    <g:hiddenField name="version" value="${this.user?.version}" />
                                                    <div class="form-group"><label class="col-sm-2 control-label">Nombre(s) </label>
                                                        <div class="col-sm-5"><input name="nombre" id="nombre" style="text-transform: uppercase" type="text" class="form-control" value="${user?.nombre}" onBlur="this.value=this.value.toUpperCase();" required /></div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group"><label class="col-sm-2 control-label">Apellido Paterno </label>
                                                        <div class="col-sm-5"><input name="apellidoPaterno" id="apellidoPaterno" style="text-transform: uppercase" type="text" class="form-control" value="${user?.apellidoPaterno}" onBlur="this.value=this.value.toUpperCase();" required /></div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group"><label class="col-sm-2 control-label">Apellido Materno </label>
                                                        <div class="col-sm-5"><input name="apellidoMaterno" id="apellidoMaterno" style="text-transform: uppercase" type="text" class="form-control" value="${user?.apellidoMaterno}" onBlur="this.value=this.value.toUpperCase();" required /></div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group"><label class="col-sm-2 control-label">E-mail </label>
                                                        <div class="col-sm-5"><input name="email" id="email" type="email" class="form-control" value="${user?.email}" required /></div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group"><label class="col-sm-2 control-label">Tipo de Usuario <br/></label>
                                                        <div class="col-sm-10">
                                                            <label class="radio-inline"> 
                                                                <input type="radio" onchange="generarUsername();" onclick="mostrarGerente();" value="INTERNO" name="tipoDeUsuario" id="tipoDeUsuario" <g:if test="${user?.tipoDeUsuario.equals('INTERNO')}"> checked="true" </g:if> /> Interno
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" onchange="generarUsername();" onclick="mostrarProveedor();" value="PROVEEDOR" name="tipoDeUsuario" id="tipoDeUsuario" <g:if test="${user?.tipoDeUsuario.equals('PROVEEDOR')}"> checked="true" </g:if> /> Externo (Proveedor)
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" onchange="generarUsername();" onclick="mostrarResponsable();" value="EXTERNO" name="tipoDeUsuario" id="tipoDeUsuario" <g:if test="${user?.tipoDeUsuario.equals('EXTERNO')}"> checked="true" </g:if> /> Externo (Despacho)
                                                            </label>
                                                        </div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <label class="col-md-2 control-label">Delegación </label>
                                                            <div class="col-md-3">
                                                                <div class="input-group">
                                                                    <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:350px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort: 'nombre')}" value="${user?.delegacion?.id}" optionKey="id" onchange="definirCatalogo(escape(this.value));" />
                                                                </div>
                                                            </div>
                                                            <div id="divDespacho">
                                                                <label class="col-md-2 control-label">Despacho </label>
                                                                <div class="col-md-3">
                                                                    <div class="input-group">
                                                                        <g:select data-placeholder="Elija un Despacho..." class="chosen-select" style="width:350px;" tabindex="2" name="despacho.id" id="despacho" from="${mx.gox.infonavit.sicj.admin.Despacho?.findAllWhere(delegacion: user?.delegacion)}" value="${user?.despacho?.id}" optionKey="id" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div id="divProveedor">
                                                                <label class="col-md-2 control-label">Proveedor </label>
                                                                <div class="col-md-3">
                                                                    <div class="input-group">
                                                                        <g:select data-placeholder="Elija un Proveedor..." class="chosen-select" style="width:350px;" tabindex="2" name="proveedor.id" id="proveedor" from="${mx.gox.infonavit.sicj.admin.Proveedor?.findAllWhere(delegacion: user?.delegacion)}" value="${user?.proveedor?.id}" optionKey="id" />  
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <label class="col-md-2 control-label">Username </label>
                                                            <div class="col-md-3">
                                                                <input id="username" readonly name="username" style="text-transform: uppercase" type="text" class="form-control" value="${user?.username}">
                                                            </div>
                                                            <label class="col-md-2 control-label">Contraseña </label>
                                                            <div class="col-md-4">
                                                                <input type="password" class="form-control" name="password" id="password" value="${user?.password}">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <label class="col-md-2 control-label">Cuenta Activa </label>
                                                            <div class="col-md-3">
                                                                <g:checkBox id="enabled" name="enabled"  class="js-switch" checked="${user?.enabled}" value="${user?.enabled}" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="hr-line-dashed"></div>
                                                    <div id="divResponsable" class="form-group"><label class="col-sm-2 control-label">Responsable del Despacho </label>
                                                        <div class="col-sm-5"><g:checkBox id="responsableDelDespacho" name="responsableDelDespacho"  class="js-switch" checked="${user?.responsableDelDespacho}" value="${user?.responsableDelDespacho}" /></div>
                                                    </div>
                                                    <div id="divGerente" class="form-group"><label class="col-sm-2 control-label">Gerente Jurídico </label>
                                                        <div class="col-sm-5"><g:checkBox id="gerenteJuridico" name="gerenteJuridico"  class="js-switch" checked="${user?.gerenteJuridico}" value="${user?.gerenteJuridico}" /></div>
                                                    </div>
                                                    <div id="divRespProveedor" class="form-group"><label class="col-sm-2 control-label">Proveedor Responsable </label>
                                                        <div class="col-sm-5"><g:checkBox id="proveedorResponsable" name="proveedorResponsable"  class="js-switch" checked="${user?.proveedorResponsable}" value="${user?.proveedorResponsable}" /></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="tab-7" class="tab-pane">
                                            <div class="panel-body">
                                                <div class="alert alert-info">
                                                    <p><span class="badge badge-success">Consejo</span> Para una administración más sencilla, puede seleccionar los perfiles que requiera, sin la necesidad de elegir cada rol individualmente, ya que de forma automática se asignarán los roles asociados al perfil hacía el usuario seleccionado</p>
                                                </div>
                                                <div class="ibox-content">
                                                    <g:if test='${grantedPerfilesList}'>
                                                        <g:each var='perfil' in='${grantedPerfilesList}'>
                                                            <div class="row">
                                                                <div class="checkbox checkbox-primary checkbox-circle col-sm-4">
                                                                    <input type="checkbox" id="PROFILE_${perfil.id}" checked name='PROFILE_${perfil.id}'/>
                                                                    <label for='PROFILE_${perfil.name}'>${perfil.name}</label>
                                                                </div>
                                                                <div class="col-sm-2">
                                                                    <button value="${perfil.id}" class="btn btn-warning" type="button" onclick="${remoteFunction(controller : 'perfil', action : 'obtenerRolesDelPerfil', params : '\'perfil=\' + escape(this.value)', onSuccess : 'verRoles(data)')}">Ver Roles Asociados</button>
                                                                </div>
                                                            </div>
                                                        </g:each>
                                                    </g:if>
                                                    <g:if test='${nonGrantedPerfilesList}'>
                                                        <g:each var='perfil' in='${nonGrantedPerfilesList}'>
                                                            <div class="row">
                                                                <div class="checkbox checkbox-primary checkbox-circle col-sm-4">
                                                                    <input type="checkbox" id="PROFILE_${perfil.id}" name='PROFILE_${perfil.id}'/>
                                                                    <label for='PROFILE_${perfil.name}'>${perfil.name}</label>
                                                                </div>
                                                                <div class="col-sm-2">
                                                                    <button value="${perfil.id}" class="btn btn-warning" type="button" onclick="${remoteFunction(controller : 'perfil', action : 'obtenerRolesDelPerfil', params : '\'perfil=\' + escape(this.value)', onSuccess : 'verRoles(data)')}">Ver Roles Asociados</button>
                                                                </div>
                                                                <div id="rolesPerfil${perfil.id}" ></div>
                                                            </div>
                                                        </g:each>
                                                    </g:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="tab-8" class="tab-pane">
                                            <div class="panel-body">
                                                <div class="ibox-content">
                                                    <g:if test='${grantedRolesList}'>
                                                        <g:each var='role' in='${grantedRolesList}'>
                                                            <div class="checkbox checkbox-success checkbox-circle tooltip-demo">
                                                                <g:set var='authority' value='${uiPropertiesStrategy.getProperty(role, 'authority')}'/>
                                                                <input type="checkbox" id="${authority}" checked name='${authority}'/>
                                                                <label for='${authority}' data-toggle='tooltip' data-placement='right' title='${role.descripcion}'>${authority}</label>
                                                            </div>
                                                        </g:each>
                                                    </g:if>
                                                    <g:if test='${nonGrantedRolesList}'>
                                                        <g:each var='role' in='${nonGrantedRolesList}'>
                                                            <div class="checkbox checkbox-success checkbox-circle tooltip-demo">
                                                                <g:set var='authority' value='${uiPropertiesStrategy.getProperty(role, 'authority')}'/>
                                                                <input type="checkbox" id="${authority}" name='${authority}'/>
                                                                <label for='${authority}' data-toggle='tooltip' data-placement='right' title='${role.descripcion}'>${authority}</label>
                                                            </div>
                                                        </g:each>
                                                    </g:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-4 col-sm-offset-2">
                                    <button class="btn btn-white" type="submit">Cancelar</button>
                                    <button class="btn btn-primary" type="submit">Guardar</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="modal inmodal fade" id="modalRolesPerfil" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                        <h5 class="modal-title">Roles Asociados</h5>
                        <h5 class="modal-title" id="tituloModal">Perfil</h5>
                    </div>
                    <div class="modal-body">
                        <div id="rolesPerfil" ></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function generarUsername() {
        if($("input:radio[name=tipoDeUsuario]:checked").val() == 'INTERNO'){
        $('#username').val(('IN' + ($('#nombre').val().substring(0,2)) + ($('#apellidoPaterno').val().substring(0,2)) + ($('#apellidoMaterno').val().substring(0,2))));
        } else if($("input:radio[name=tipoDeUsuario]:checked").val() == 'EXTERNO' || $("input:radio[name=tipoDeUsuario]:checked").val() == 'PROVEEDOR'){
        $('#username').val('externo');
        $('#username').val(('IE' + ($('#nombre').val().substring(0,2)) + ($('#apellidoPaterno').val().substring(0,2)) + ($('#apellidoMaterno').val().substring(0,2)) + (('0' + ($('#delegacion').val()).slice (-2)))));
        }
        }

        function mostrarResponsable(){
        $('#divGerente').hide('slow');
        $('#divProveedor').hide('slow');
        $('#divRespProveedor').hide('slow');
        $('#divResponsable').show('slow');
        $('#divDespacho').show();
        }

        function mostrarGerente(){
        $('#divResponsable').hide('slow');
        $('#divProveedor').hide('slow');
        $('#divRespProveedor').hide('slow');
        $('#divGerente').show('slow');
        $('#divDespacho').hide();
        }

        function mostrarProveedor(){
        $('#divResponsable').hide('slow');
        $('#divGerente').hide('slow');
        $('#divDespacho').hide();
        $('#divProveedor').show('slow');
        $('#divRespProveedor').show('slow');
        }

        function definirCatalogo(delegacion){
        if($("input:radio[name=tipoDeUsuario]:checked").val() == 'EXTERNO'){
        obtenerListados(delegacion,'despacho','obtenerDespachos');
        } else if($("input:radio[name=tipoDeUsuario]:checked").val() == 'PROVEEDOR'){
        obtenerListados(delegacion,'proveedor','obtenerProveedores');
        }
        }

        function obtenerListados(delegacion,catalogo,metodo){
        $.ajax({
        type:'POST',
        data:'delegacion=' + delegacion,
        url:'/sicj/' + catalogo + '/' + metodo,
        success:function(data,textStatus){
        actualizar(data, catalogo);
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}});
        }

        function actualizar(data, tipo) {
        var resultado = eval(data);
        var html = "";
        html += "<option value='null'>Elija una opción...</option>";
        for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
        }
        $('#' + tipo).html(html);
        $('#' + tipo).trigger("chosen:updated");
        generarUsername();
        }

        function verRoles(data) {
        var resultado = eval(data);
        var html = "<div class='tooltip-demo'>";
        for (var x = 0; x < resultado.roles.length; x++) {
            html += "<li><label data-toggle='tooltip' data-placement='right' title='" + resultado.roles[x].descripcion + "'><strong>" + resultado.roles[x].authority + "</strong></label></li>";          
        }
        html += "</div>";
        $('#tituloModal').text(resultado.perfil.name);
        $('#rolesPerfil').html(html);
        $('#modalRolesPerfil').modal('show');
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
        if($("input:radio[name=tipoDeUsuario]:checked").val() == 'INTERNO'){
        mostrarGerente();
        } else if($("input:radio[name=tipoDeUsuario]:checked").val() == 'EXTERNO'){
        mostrarResponsable();
        }  else if($("input:radio[name=tipoDeUsuario]:checked").val() == 'PROVEEDOR'){
        mostrarProveedor();
        }
        });
    </script>
<s2ui:documentReady>
    $("#runAsButton").button();
    $('#runAsButton').bind('click', function() {
    document.forms.runAsForm.submit();
    });
</s2ui:documentReady>
</body>
</html>
