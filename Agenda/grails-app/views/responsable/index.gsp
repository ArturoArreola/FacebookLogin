<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'responsable.label', default: 'Responsable')}" />
        <title><g:message code="Lista de personas" args="[entityName]" /></title>
    </head>
    <body>
        <a href="#list-responsable" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="Agregar nueva persona" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="list-responsable" class="content scaffold-list" role="main">
            <h1><g:message code="Lista de personas" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:table collection="${responsableList}" />

            <div class="pagination">
                <g:paginate total="${responsableCount ?: 0}" />
            </div>
        </div>
    </body>
</html>