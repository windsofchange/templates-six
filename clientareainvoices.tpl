{include file="$template/includes/tablelist.tpl" tableName="InvoicesList" filterColumn="4"}
<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableInvoicesList').removeClass('hidden').DataTable();
        {if $orderby == 'default'}
            table.order([4, 'desc'], [2, 'desc'], [1, 'desc']);
        {elseif $orderby == 'invoicenum'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'date'}
            table.order(1, '{$sort}');
        {elseif $orderby == 'duedate'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'total'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'status'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>

<div class="table-container clearfix">
    <table id="tableInvoicesList" class="table table-list hidden">
        <thead>
            <tr>
                <th>{$LANG.invoicestitle}</th>
                <th>{$LANG.invoicesdatecreated}</th>
                <th>{$LANG.invoicesdatedue}</th>
                <th>{$LANG.invoicestotal}</th>
                <th>{$LANG.invoicesstatus}</th>
                <th class="responsive-edit-button" style="display: none;"></th>
            </tr>
        </thead>
        <tbody>
            {foreach key=num item=invoice from=$invoices}
            {if $invoice.rawstatus neq "cancelled"}
                <tr {if $invoice.statusClass eq "unpaid"} onclick="clickableSafeRedirect(event, 'viewinvoice.php?id={$invoice.id}', false)" {/if}>
                    <td><a data-toggle="tooltip" title="Download PDF" href="dl.php?type=i&id={$invoice.id}"> <i class="fas fa-download fa-fw" style="font-size: 1.17em;color=#636363"></i></a>&nbsp;&nbsp;
                    {$invoice.id} {if $invoice.statusClass eq "paid"} // {* Paid Invoice#*} {$invoice.invoicenum}{/if}{$item.description}</td>
                    <td>
                    {if $invoice.statusClass eq "paid"}
                        <span class="hidden">{$invoice.normalisedDateCreated}</span>{$invoice.datecreated}
                    {elseif $invoice.statusClass eq "unpaid"}
                            {if $invoice.datedue|strtotime < $todaysdate|strtotime}
                                <a data-toggle='tooltip' href="submitticket.php?step=2&deptid=3&subject=PastDue-Invoice#{$invoice.id}" title='We value your comments, click to open ticket' />
                                    <i style='color:#636363;font-size:1.1em;' class='glyphicon glyphicon-off'></i> {$LANG.invoicespastduedate},</a>
                                    <a href="viewinvoice.php?id={$invoice.id}" data-toggle="tooltip" title="Pay Now">{$LANG.invoicesoverduedate}</a>
                            {elseif $invoice.datedue|strtotime == $todaysdate|strtotime}
            <a href="viewinvoice.php?id={$invoice.id}" data-toggle="tooltip" title="Click to Pay Now">{$LANG.invoicesduetoday}</a>
                            {else}
            <a href="viewinvoice.php?id={$invoice.id}" data-toggle="tooltip" title="Click Pay Invoice">{$LANG.invoicesnotdue}</a>
                           {/if}
                    {/if}
                    </td>
                    <td>{if $invoice.statusClass eq "unpaid"}<span class="hidden">{$invoice.normalisedDateDue}</span>{$invoice.datedue}{/if}</td>
                    <td data-order="{$invoice.totalnum}">{$invoice.total}</td>
                    <td><span class="label status status-{$invoice.statusClass}">{$invoice.status}</span></td>
                    <td class="responsive-edit-button" style="display: none;">
                        <a href="viewinvoice.php?id={$invoice.id}" class="btn btn-block btn-info">
                            {$LANG.invoicesview}
                        </a>
                    </td>
                </tr>
            {/if}
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>
{include file="$template/includes/alert.tpl" type="warning" msg=$LANG.activeinvoicelistingonly}
