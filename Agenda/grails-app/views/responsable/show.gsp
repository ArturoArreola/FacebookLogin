<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <g:set var="entityName" value="${message(code: 'responsable.label', default: 'Responsable')}" />
        <title><g:message code="Datos de la persona" args="[entityName]" /></title>
    </head>
    <body>
        <a href="#show-responsable" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="Lista de personas" args="[entityName]" /></g:link></li>
                <li><g:link class="create" action="create"><g:message code="Agregar nueva persona" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="show-responsable" class="content scaffold-show" role="main">
            <h1><g:message code="Datos de la persona" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:display bean="responsable" />
            <g:form resource="${this.responsable}" method="DELETE">
                <fieldset class="buttons">
                    <g:link class="edit" action="edit" resource="${this.responsable}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                    <input class="delete" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                </fieldset>
            </g:form>
        </div>
    </body>
</html>
