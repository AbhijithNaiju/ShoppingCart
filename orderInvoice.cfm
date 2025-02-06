<cfif structKeyExists(url, "orderId")>
	<cfset variables.orderHistory=application.userObject.getOrderHistory(orderId=url.orderId)>
	<cfset variables.fileName = url.orderId & '_' & dateTimeFormat(now(),"dd_mm_yy_hh_nn_ss_tt")&'.pdf'>
	<cfset variables.downloadLocation = "/assets/invoiceDownloads">
	<cfset variables.absoluteFileName = expandPath(variables.downloadLocation)&'\'&variables.fileName>
	<cfdocument 
		format="pdf" 
		filename="#variables.absoluteFileName#" 
		overwrite="Yes"
	>
		<html>
			<head>
				<title>Hello World</title>
				<style>
					.pdfHeader{
						background-color: lightgreen;
						padding: 20px;
						font-size:22px;
					}
					.pdfcontent {
						text-align: center;
					}
					table{
						width:100%;
						border: 1px solid ##000;
					}
					th,td{
						text-align:center;
					}
					.invoiceBody{
						padding:3px;
					}
					.addressDetails{
						font-size: 14px;
					}
					.orderDate{
						width:50%;
					}
				</style>
			</head>
			<body>
				<cfoutput>
					<div align="center" class="header">
						<h1>ORDER INVOICE</h1>
					</div>
					<div class = "invoiceBody">
						<div class = "pdfHeader">
							<span>ORDER ID : #url.orderId#</span>
						</div>   
						<div class="pdfcontent">
							<table>
								<thead>
									<tr>
										<th>Product Name</th>
										<th>Brand</th>
										<th>Quantity</th>
										<th>Price</th>
										<th>Tax</th>
										<th>Total Cost</th>
									</tr>
								</thead>
								<cfloop query="variables.orderHistory">
									<tr>
										<td>#variables.orderHistory.productName#</td>
										<td>#variables.orderHistory.brandName#</td>
										<td>#variables.orderHistory.Quantity#</td>
										<td>#variables.orderHistory.unitPrice#</td>
										<td>#variables.orderHistory.unitTax#</td>
										<td>#variables.orderHistory.unitPrice * variables.orderHistory.unitPrice#</td>
									</tr>
								</cfloop>
							</table>
						<div>
							<span class = "orderDate">
								Order Date : #variables.orderHistory.orderDate#
							</span>
							<span>
								Total Price : #variables.orderHistory.totalPrice + variables.orderHistory.totalTax#
							</span>
						</div>
						</div>
					</div>
					<div class = "addressDetails">
						<b>Address details :</b> 
						<div>
							#variables.orderHistory.firstName & ' ' & variables.orderHistory.lastName#
						</div>
						<div>
							#variables.orderHistory.addressLine1 & ' ' & variables.orderHistory.addressLine2 & ' ' & variables.orderHistory.city#
							#variables.orderHistory.state & ' - ' & variables.orderHistory.pincode#
						</div>
						<div>Phone : #variables.orderHistory.phoneNumber#</div>
					</div>
				</cfoutput>
			</body>
		</html>
	</cfdocument>
	<!--- <cfheader 
		name="Content-Disposition" 
		value="attachment;filename=#variables.fileName#"
	> --->
	<cfheader name="Content-Type" value="application/pdf">
	<cfcontent
		type="application/pdf"
		file="#variables.absoluteFileName#"
	>
</cfif>