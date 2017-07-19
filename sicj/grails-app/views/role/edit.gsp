<html>
    <head>
        <meta name="layout" content="inspinia"/>
    <s2ui:title messageCode='default.edit.label' entityNameMessageCode='role.label' entityNameDefault='Role'/>
</head>
<body>
    <div class="row wrapper border-bottom white-bg page-heading">
        <div class="col-sm-4">
            <h2>Cónsola de Administración</h2>
            <ol class="breadcrumb">
                <li>
                    <a href="index.html">Roles</a>
                </li>
                <li class="active">
                    <strong>Edición de Roles</strong>
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
                        <h5>Editar Rol</h5>
                    </div>
                    <form class="form-horizontal" action="/sicj/role/update" method="post" name="updateForm" id="search">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="tabs-container">
                                    <ul class="nav nav-tabs">
                                        <li class="active"><a data-toggle="tab" href="#tab-6">Datos Generales</a></li>
                                        <li class=""><a data-toggle="tab" href="#tab-7">Perfiles</a></li>
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
                                                    <g:hasErrors bean="${this.role}">
                                                        <g:eachError bean="${this.role}" var="error">
                                                            <g:if test="${error in org.springframework.validation.FieldError}">
                                                                <div class="alert alert-danger alert-dismissable">
                                                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                                                    <g:message error="${error}"/>
                                                                </div>
                                                            </g:if>
                                                        </g:eachError>
                                                    </g:hasErrors>
                                                    <g:hiddenField name="version" value="${role?.version}" />
                                                    <g:hiddenField name="id" value="${role?.id}" />
                                                    <g:hiddenField name="version" value="${this.role?.version}" />
                                                    <div class="form-group"><label class="col-sm-2 control-label">Nombre del Rol </label>
                                                        <div class="col-sm-5"><input name="authority" id="nombre" readonly style="text-transform: uppercase" type="text" class="form-control" value="${role?.authority}" required></div>
                                                    </div>
                                                    <div class="form-group"><label class="col-sm-2 control-label">Descripción del Rol </label>
                                                        <div class="col-sm-5"><textarea name="descripcion" id="descripcion" readonly style="text-transform: uppercase; height: 120px;" class="form-control" required>${role?.descripcion}</textarea></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="tab-7" class="tab-pane">
                                            <div class="panel-body">
                                                <div class="alert alert-info">
                                                    <p><span class="badge badge-success">Consejo</span> Para una administración más sencilla, puede asociar el rol al perfil deseado, ya que de forma automática se asignarán los roles asociados al perfil hacía el usuario seleccionado</p>
                                                </div>
                                                <div class="ibox-content">
                                                    <g:if test='${grantedPerfilesList}'>
                                                        <g:each var='perfil' in='${grantedPerfilesList}'>
                                                            <div class="row">
                                                                <div class="checkbox checkbox-primary checkbox-circle col-sm-4">
                                                                    <input type="checkbox" id="PROFILE_${perfil.id}" checked name='PROFILE_${perfil.id}'/>
                                                                    <label for='PROFILE_${perfil.name}'>${perfil.name}</label>
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
                                    <g:link action='search' class="btn btn-warning">Regresar</g:link>
                                    <button class="btn btn-primary" type="submit">Guardar</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
