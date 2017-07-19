<g:if test="${juiciosContingentes}">
    <div class="col-lg-12">
        <div class="row">
            <div class=" panel panel-primary">
                <div class="panel-heading">
                    Asuntos Contingentes al <strong><g:formatDate format="dd/MM/yyyy HH:mm" date="${new Date()}"/></strong>
                </div>
                <div class="panel-body">
                    <table style="width:100%;font-size: 11px;" class="table table-hover dataTables">
                        <thead>
                            <tr>
                                <th style="text-align: center;">Delegación</th>
                                <th style="text-align: center;">Despacho</th>
                                <th style="text-align: center;">Expediente Interno</th>
                                <th style="text-align: center;">Expediente del Juicio</th>
                                <th style="text-align: center;">Estatus</th>
                                <th style="text-align: center;">Ver Juicio</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each var='juicio' in='${juiciosContingentes}'>
                                <tr>
                                    <td style="text-align: center;">${juicio.delegacion}</td>
                                    <td style="text-align: center;">${juicio.despacho}</td>
                                    <td style="text-align: center;">${juicio.expedienteInterno}</td>
                                    <td style="text-align: center;">${juicio.expediente}</td>
                                    <td style="text-align: center;">${juicio.estadoDeJuicio}</td>
                                    <td style="text-align: center;"><g:link controller='juicio' action='show' id='${juicio.id}' class="btn btn-success btn-xs"><i class="fa fa-legal"></i></g:link></td>
                                    </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</g:if>
<g:else>
    No hay Asuntos registrados como <span class='badge badge-danger'>Contingentes</span>
</g:else>