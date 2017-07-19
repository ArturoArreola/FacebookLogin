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
                    <strong>Buscar Rol</strong>
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
                        <h5>Buscar Rol</h5>
                    </div>
                    <div class="ibox-content">
                        <form class="form-horizontal" action="/sicj/role/search" method="post" name="search" id="search">
                            <div class="form-group"><label class="col-sm-2 control-label">Nombre del Rol:</label>

                                <div class="col-sm-10"><input type="text" class="form-control" name='authority' size='50' maxlength='255' autocomplete='off'/></div>
                            </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <div class="col-sm-4 col-sm-offset-2">
                                    <button class="btn btn-primary" type="submit">Buscar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <g:if test='${searched}'>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Resultados</h5>
                        </div>
                        <div class="ibox-content">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Nombre de Rol</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in='${results}' status='i' var='role'>
                                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                                <td><g:link action='edit' id='${role.id}'>${uiPropertiesStrategy.getProperty(role, 'authority')}</g:link></td>
                                                <td><p>${role.descripcion}</p></td>
                                            </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                                <div class="pagination">
                                    <g:paginate action="search" total="${totalCount ?: 0}" params="${[authority: params.authority]}"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </g:if>
        <s2ui:ajaxSearch paramName='authority' minLength='2'/>
    </div>
</body>
</html>
