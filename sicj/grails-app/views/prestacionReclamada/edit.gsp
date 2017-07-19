<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'prestacionReclamada.label', default: 'Prestación Reclamada')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Catálogos</a>
                    </li>
                    <li class="active">
                        <strong>Edición de Prestaciones Reclamadas</strong>
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
                            <h5>Editar Prestación Reclamada</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="show" style="color:#ffffff;" id="${this.prestacionReclamada.id}">Regresar</g:link>
                                </div>
                            </div>
                            <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.prestacionReclamada}">
                                <g:eachError bean="${this.prestacionReclamada}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form class="form-horizontal" resource="${this.prestacionReclamada}" method="PUT">
                                <g:hiddenField name="version" value="${this.prestacionReclamada?.version}" />
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Nombre de la Prestación Reclamada *</label>
                                    <div class="col-md-10">
                                        <input id="nombre" name="nombre" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required value="${prestacionReclamada.nombre}"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Descripción *</label>
                                    <div class="col-md-10">
                                        <input id="descripcion" name="descripcion" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required value="${prestacionReclamada.descripcion}" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Materia *</label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija la materia..." required class="chosen-select" style="width:350px;" tabindex="2" name="materia.id" from="${mx.gox.infonavit.sicj.catalogos.Materia.findAll('from Materia m where m.id in (1,2) order by m.id')}" value="${prestacionReclamada.materia.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <div class="col-lg-6 col-lg-offset-2">
                                        <div class="form-group">
                                            <g:submitButton name="create" class="btn btn-warning" value="Actualizar" />
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
</body>
</html>