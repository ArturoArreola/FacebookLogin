<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'perfil.label', default: 'Perfil')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Perfiles</a>
                    </li>
                    <li class="active">
                        <strong>Edición de Perfiles</strong>
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
                            <h5>Editar Perfil</h5>
                        </div>
                        <g:form resource="${this.perfil}" method="PUT" class="form-horizontal">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="tabs-container">
                                        <ul class="nav nav-tabs">
                                            <li class="active"><a data-toggle="tab" href="#tab-6">Datos Generales</a></li>
                                            <li class=""><a data-toggle="tab" href="#tab-7">Roles</a></li>
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
                                                        <g:hasErrors bean="${this.perfil}">
                                                            <g:eachError bean="${this.perfil}" var="error">
                                                                <g:if test="${error in org.springframework.validation.FieldError}">
                                                                    <div class="alert alert-danger alert-dismissable">
                                                                        <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                                                        <g:message error="${error}"/>
                                                                    </div>
                                                                </g:if>
                                                            </g:eachError>
                                                        </g:hasErrors>
                                                        <g:hiddenField name="version" value="${perfil?.version}" />
                                                        <g:hiddenField name="id" value="${perfil?.id}" />
                                                        <div class="form-group"><label class="col-sm-2 control-label">Nombre del Perfil: </label>
                                                            <div class="col-sm-10"><input type="text" class="form-control" name='name' size='50' maxlength='255' autocomplete='off' value='${perfil.name}' onBlur="this.value=this.value.toUpperCase();"/></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="tab-7" class="tab-pane">
                                                <div class="panel-body">
                                                    <div class="ibox-content">
                                                        <g:if test="${rolesMap}">
                                                            <g:each var="entry" in="${rolesMap}">
                                                                <div class="checkbox checkbox-success checkbox-circle tooltip-demo">
                                                                    <g:checkBox id="${entry.authority}" name="${entry.authority}" checked="${entry.asociado}" value="${entry.id}"/>
                                                                     <label for='${entry.authority}' data-toggle='tooltip' data-placement='right' title='${entry.descripcion}'><strong>${entry.authority}</strong></label>
                                                                </div>
                                                            </g:each>
                                                        </g:if>
                                                        <g:else>
                                                            No hay roles registrados.
                                                        </g:else>    
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <g:link action='show' id='${perfil?.id}' class="btn btn-warning">Regresar</g:link>
                                        <button class="btn btn-primary" type="submit">Guardar</button>
                                    </div>
                                </div>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
