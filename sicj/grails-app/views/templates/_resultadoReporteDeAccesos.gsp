
<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>Reporte de Acceso / Movimientos</h5>
            </div>
            <div class="ibox-content">
                <div class="table-responsive">
                    <g:if test='${reporte}'>
                        <h4>Accesos</h4>
                        <table class="table table-striped table-bordered table-hover dataTables" data-page-size="10">
                            <thead>
                                <tr>
                                    <th>Nombre de Usuario </th>
                                    <th>Delegación/Despacho </th>
                                    <th>Tipo de Usuario </th>
                                    <th>Evento </th>
                                    <th>Fecha </th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each var='registroReporte' in='${reporte}'>
                                    <g:each var='registro' in='${registroReporte.resultado?.ultimosAccesos}'>
                                        <tr>
                                            <td>${registroReporte.usuario}</td>
                                            <td>${registroReporte.usuario?.delegacion} / ${registroReporte.usuario?.despacho}</td>
                                            <td>${registroReporte.usuario?.tipoDeUsuario}</td>
                                            <td>${registro.tipoDeEvento}</td>
                                            <td>${registro.fechaDeEvento} </td>
                                        </tr>
                                    </g:each>
                                </g:each>
                            </tbody>
                        </table>
                        <br />
                        <h4>Movimientos</h4>
                        <table class="table table-striped table-bordered table-hover dataTables" data-page-size="10">
                            <thead>
                                <tr>
                                    <th>Nombre de Usuario </th>
                                    <th>Delegación/Despacho </th>
                                    <th>Tipo de Usuario </th>
                                    <th>Evento </th>
                                    <th>Fecha </th>
                                    <th>No. de Expediente </th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each var='registroReporte' in='${reporte}'>
                                    <g:each var='registro' in='${registroReporte.resultado?.ultimosMovimientos}'>
                                        <tr>
                                            <td>${registroReporte.usuario}</td>
                                            <td>${registroReporte.usuario?.delegacion} / ${registroReporte.usuario?.despacho}</td>
                                            <td>${registroReporte.usuario?.tipoDeUsuario}</td>
                                            <td>${registro.descripcion}</td>
                                            <td>${registro.fecha} </td>
                                            <td>${registro.juicio?.expediente} </td>
                                        </tr>
                                    </g:each>
                                </g:each>
                            </tbody>
                        </table>
                    </g:if>
                    <g:else>
                        <p>No hay resultados que mostrar</p>
                    </g:else>
                </div>
            </div>
        </div>
    </div>
</div>
