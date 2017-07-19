<html>
    <head>
        <meta name="layout" content="inspinia"/>
    <s2ui:title messageCode='spring.security.ui.role.search'/>
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
                    <strong>Listado de Roles</strong>
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
                        <h5>Listado de Roles</h5>
                    </div>
                    <div class="ibox-content">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Nombre de Rol</th>
                                        <th>Descripción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <g:each in='${rolList}' status='i' var='role'>
                                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                            <td><g:link action='edit' id='${role.id}'>${uiPropertiesStrategy.getProperty(role, 'authority')}</g:link></td>
                                            <td><p>${role.descripcion}</p></td>
                                        </tr>
                                    </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
