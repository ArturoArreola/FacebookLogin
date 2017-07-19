<div class="col-lg-12">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>Resultados de la búsqueda</h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content" style="overflow-y: auto; max-height: calc(100vh - 210px);">
            <g:if test="${resultados}">
                <center>
                    <div class="alert alert-info">
                        Se han encontrado <strong>${resultados.size()}</strong> coincidencias.
                    </div>
                </center>
                <table style="width:100%;" id="resultadosDeBusqueda" class="table table-hover dataTables">
                    <thead>
                        <tr>
                            <th style="text-align:center;">Expediente Interno</th>
                            <th style="text-align:center;">Expediente del Juicio</th>
                            <th style="text-align:center;">Tipo de Juicio</th>
                            <th style="text-align:center;">Delegación</th>
                            <th style="text-align:center;">Actor/<br/>Denunciante</th>
                            <th style="text-align:center;">Demandado/<br/>Propable Responsable</th>
                            <th style="text-align:center;">Etapa Procesal</th>
                            <th style="text-align:center;">Estatus</th>
                            <th style="text-align:center;">Seguimiento</th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:each var='juicio' in='${resultados}'>
                            <tr>
                                <td>${juicio.expedienteInterno}</td>
                                <td>${juicio.expediente}</td>
                                <td>${juicio.tipoDeProcedimiento}</td>
                                <td>${juicio.delegacion.nombreCorto}</td>
                                <td>
                                    <g:each status='i' var='actor' in='${actores[juicio.id]}'>
                                        <g:if test="${i < 5}">
                                <li>${actor?.persona}</li>
                                </g:if>
                            </g:each>
                            <g:if test="${(actores[juicio.id])?.size() > 5}">
                        <center><button type="button" class="btn-xs btn-default btn-bitbucket" onclick="mostrarListaCompleta(${juicio.id},'actores');">Ver la lista completa</button></center>
                        </g:if>
                    </td>
                    <td>
                        <g:each status='j' var='demandado' in='${demandados[juicio.id]}'>
                            <g:if test="${j < 5}">
                            <li>${demandado?.persona}</li>
                            </g:if>
                        </g:each>
                        <g:if test="${(demandados[juicio.id])?.size() > 5}">
                    <center><button type="button" class="btn-xs btn-default btn-bitbucket" onclick="mostrarListaCompleta(${juicio.id},'demandados');">Ver la lista completa</button></center>
                    </g:if>
                </td>
                <td>${(juicio.etapaProcesal?: "WF SIN CONTESTAR")}</td>
                <td align="center">
                    <% def colores = ["#fa9d4b","#1ab394","#79d2c0","#d54545","#bf00ff","#45c6d5","#848484"] %>
                    <span  class="badge" style="width: 100%; color: #FFFFFF; background-color: ${colores.getAt((juicio.estadoDeJuicio.id as int) -1)};">
                        <strong>${juicio.estadoDeJuicio}</strong>
                    </span>
                </td>
                <td align="center">
                <center>
                    <g:if test="${juicio.provision.id == 1}">
                        <span class="label label-danger" title="CONTINGENTE">C</span>
                    </g:if>
                    <g:if test="${juicio.provision.id == 2}">
                        <span class="label label-primary" title="NO CONTINGENTE">N</span>
                    </g:if>
                    <g:if test="${juicio.provision.id == 3}">
                        <span class="label label-warning" title="POSIBLE CONTINGENTE">P</span>
                    </g:if>
                    <a class="btn-xs btn-success btn-bitbucket" title="VER DETALLES" onclick="mostrarDespacho('<strong>Despacho: </strong> ${juicio.despacho?.toString()}');"><i class="fa fa-eye"></i></a>
                    <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_SEGUIMIENTO_JUICIO_LABORAL,ROLE_SEGUIMIENTO_JUICIO_CIVIL,ROLE_SEGUIMIENTO_JUICIO_PENAL,ROLE_SEGUIMIENTO_JUICIO_LABORAL_NACIONAL,ROLE_SEGUIMIENTO_JUICIO_CIVIL_NACIONAL,ROLE_SEGUIMIENTO_JUICIO_PENAL_NACIONAL'> 
                        <g:link action='show' id='${juicio.id}' class="btn-xs btn-info btn-bitbucket" title="IR AL JUICIO ${juicio.expedienteInterno}" target="_blank" ><i class="fa fa-legal"></i></g:link>
                    </sec:ifAnyGranted> 
                    </center>
                    </td>
                    </tr>
            </g:each>
            </tbody>
        </table>
    </g:if>
    <g:else>
        No hay resultados que mostrar, o no cuenta con permisos para visualizarlos.
    </g:else>  
</div>
</div>
</div>
<script>
    function mostrarDespacho(mensaje){
    swal({title:"<small>Detalles</small>", text: mensaje, html: true});
    }
</script>