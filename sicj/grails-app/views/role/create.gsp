<html>
    <head>
        <meta name="layout" content="inspinia"/>
    <s2ui:title messageCode='default.create.label' entityNameMessageCode='role.label' entityNameDefault='Role'/>
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
                    <strong>Creación de Roles</strong>
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
                        <h5>Crear Rol</h5>
                    </div>
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
                        <form class="form-horizontal" action="/sicj/role/save" method="post" name="saveForm" id="saveForm">
                            <div class="form-group"><label class="col-sm-2 control-label">Nombre del Rol: </label>
                                <div class="col-sm-5"><input name="authority" id="nombre" style="text-transform: uppercase" type="text" class="form-control" value="${role?.authority}" size='50' maxlength='255' autocomplete='off' onBlur="this.value=this.value.toUpperCase();" required></div>
                            </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <div class="col-sm-4 col-sm-offset-2">
                                    <button class="btn btn-white" type="submit">Cancelar</button>
                                    <button class="btn btn-primary" type="submit">Guardar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
