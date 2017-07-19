<div class="table-responsive">
    <table class="table table-striped">
        <thead>
            <tr>
                <th style="text-align: center;">Id</th>
                <th style="text-align: center;">Materia</th>
                <th style="text-align: center;">Ambito</th>
                <th style="text-align: center;">Estado/Municipio</th>
                <th style="text-align: center;">Tipo de Autoridad</th>
                <th style="text-align: center;">Autoridad</th>
                <th style="text-align: center;">Ver Detalles</th>
            </tr>
        </thead>
        <tbody>
            <g:if test="${autoridadList}">
            <g:each in='${autoridadList}' status='i' var='autoridad'>
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td style="text-align: center;">${autoridad[0]?.id}</td>
                    <td style="text-align: center;">${autoridad[0]?.materia}</td>
                    <td style="text-align: center;">${autoridad[0]?.ambito}</td>
                    <td style="text-align: center;">${autoridad[1]?.municipio?.estado} <strong>/</strong> ${autoridad[1]?.municipio}</td>
                    <td style="text-align: center;">${autoridad[0]?.tipoDeAutoridad}</td>
                    <td style="text-align: center;">${autoridad[0]?.nombre}</td>
                    <td style="text-align: center;"><g:link action='show' id='${autoridad[0]?.id}' class="btn-xs btn-info btn-bitbucket"><i class="fa fa-chevron-right"></i></g:link></td>
                </tr>
            </g:each>
            </g:if>
            <g:else>
                <tr><td colspan="7" style="text-align: center;">No hay resultados que mostrar.</td></tr>
            </g:else>    
        </tbody>
    </table>
</div>
<div class="pagination">
    <g:paginate action="index" total="${autoridadCount ?: 0}" params="${[estadoId: estadoId, tipoDeAutoridadId: tipoDeAutoridadId]}"/>
</div>