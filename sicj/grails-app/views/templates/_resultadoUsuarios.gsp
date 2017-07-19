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
                                    <th>Nombre de Usuario </th>
                                    <th>Delegación/Despacho </th>
                                    <th>Tipo de Usuario </th>
                                    <th>Cuenta Activa </th>
                                    <th>Cuenta Bloqueada </th>
                                    <th>Gerente Jurídico</th>
                                    <th>Responsable del Despacho</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><g:link action='editUser' id='${user?.id}'>${user}</g:link></td>
                                    <td>${user?.delegacion} / ${user?.despacho}</td>
                                    <td>${user?.tipoDeUsuario}</td>
                                    <td><g:if test='${user?.enabled}'><i class="fa fa-check text-navy"></i></g:if></td>
                                    <td><g:if test='${user?.accountLocked}'><i class="fa fa-check text-navy"></i></g:if></td>
                                    <td><g:if test='${user?.gerenteJuridico}'><i class="fa fa-check text-navy"></i></g:if></td>
                                    <td><g:if test='${user?.responsableDelDespacho}'><i class="fa fa-check text-navy"></i></g:if></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</g:if>