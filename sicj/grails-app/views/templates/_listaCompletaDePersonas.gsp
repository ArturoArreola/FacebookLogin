<div class="col-lg-12">
    <center><h5 class="modal-title">${titulo}</h5></center>
    <br />
    <g:if test="${personas}">
        <table style="width:100%;" class="table table-hover">
            <thead>
                <tr>
                    <th align="center">Nombre Completo</th>
                    <th align="center">NSS</th>
                    <th align="center">RFC</th>
                        <g:if test="${editar}">
                        <th align="center">Cantidad Demandada</th>
                        </g:if>
                        <g:if test="${(usuario?.tipoDeUsuario == "INTERNO") && (usuario?.delegacion?.id == 33)}">
                        <th align="center">Desistir<th>
                        </g:if>
                </tr>
            </thead>
            <tbody>
                <g:each var='persona' in='${personas}'>
                    <tr>
                        <td>${persona.persona.toString()}</td>
                        <td>${persona.persona.numeroSeguroSocial}</td>
                        <td>${persona.persona.rfc}</td>
                        <g:if test="${editar}">
                            <td align="center">${persona.cantidadDemandada}</td>
                            </g:if>
                            <g:if test="${(usuario?.tipoDeUsuario == "INTERNO") && (usuario?.delegacion?.id == 33) && (persona.haDesistido == false)}">
                            <td align="center"><center><button type="button" class="btn-xs btn-warning btn-bitbucket" onclick="marcarDesistimiento(${persona.persona.id},${persona.juicio.id});"> Desistir</button></center><td>
                        </g:if>
                        <g:elseif test="${persona.haDesistido}">
                        <td><span class="label label-danger" title="DESISTIDO">DESISTIDO</span></td>
                    </g:elseif>
                    </tr>
                </g:each>
                </tbody>
        </table>
    </g:if>
    <g:else>
        No hay elementos que mostrar.
    </g:else>  
</div>