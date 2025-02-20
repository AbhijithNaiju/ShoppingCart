<cfif structKeyExists(url, "orderId")>
	<cfset variables.orderHistory=application.userObject.getOrderHistory(
		userId=session.userSession.userId,
		orderId=url.orderId
	)>
	<cfset variables.fileName = url.orderId & '_' & dateTimeFormat(now(),"dd_mm_yyyy_hh_nn_ss_tt")&'.pdf'>

	<cfheader 
		name="Content-Disposition" 
		value="attachment;filename=#variables.fileName#"
	>
	<cfdocument 
		format="pdf" 
		overwrite="Yes"
	>
		<html>
			<head>
				<title>Hello World</title>
				<style>
					.pdfHeader{
						padding: 20px;
						font-size:22px;
					}
					.orderContent {
						text-align: center;
					}
					table{
						width:100%;
					}
					th,td{
						text-align:center;
						padding:10px;
						border:1px solid ##000;
					}
					.invoiceBody{
						padding:3px;
					}
					.addressDetails{
						font-size: 14px;
						margin-top:10px;
					}
					.priceDetails{
						text-align:right;
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
						<div class="orderContent">
							<table border=1>
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
										<td>#(variables.orderHistory.unitPrice + variables.orderHistory.unitTax)*variables.orderHistory.quantity#</td>
									</tr>
								</cfloop>
							</table>
						</div>
					</div>
					<div class = "orderDate">
						Order Date : #variables.orderHistory.orderDate#
					</div>
					<div class = "addressDetails">
						<b>Address details :</b> 
						<div>
							#variables.orderHistory.firstName & ' ' & variables.orderHistory.lastName#
						</div>
						<div>
							#variables.orderHistory.addressLine1 & ', '#
							# variables.orderHistory.addressLine2 & ', ' & variables.orderHistory.city#
							#variables.orderHistory.state & ' - ' & variables.orderHistory.pincode#
						</div>
						<div>Phone : #variables.orderHistory.phoneNumber#</div>
					</div>
					<div class = "priceDetails">
						<p>Actual Price : #variables.orderHistory.totalPrice#</p>
						<p>Total Tax : #variables.orderHistory.totalTax#</p>
						<hr>
						<b>Total Price : #variables.orderHistory.totalPrice + variables.orderHistory.totalTax#</b>
					</div>
				</cfoutput>
			</body>
		</html>
	</cfdocument>
</cfif>