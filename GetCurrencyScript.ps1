# Define the API URL and parameters
$apiUrl = "https://data.fixer.io/api/latest?access_key=5004e0d8c64029fed873e269efa91312&symbols=USD,AUD,CAD,PLN,MXN&format=1"  # Base currency is EUR

# Define the database connection details
$serverName = "(LocalDb)\MSSQLLocalDB"       
$databaseName = "CurrencyDB"     
$tableName = "CurrencyRates"     
$connectionString = "Server=$serverName;Database=$databaseName;Integrated Security=True;"  

# Fetch the currency rates from the API
$response = Invoke-RestMethod -Uri $apiUrl -Method Get

# Check if the response is valid
if ($response) {

    $baseCurrency = "EUR"
    $rates = $response.rates
    $date = $response.date

    # Load the SqlServer module
    Import-Module SqlServer

    # Connect to the SQL Server and insert the currency rate for USD, AUD, CAD,... (TODO: change to a loop)
        Write-Host $rates["USD"]
        $currency = "USD"
        $exchangeRate = $rates["USD"]
        
        # Build the SQL query
        $sqlQuery = @"
        INSERT INTO $tableName (BaseCurrency, TargetCurrency, ExchangeRate, DateFetched)
        VALUES ('$baseCurrency', '$currency', $exchangeRate, '$date')
"@
        
        # Execute the SQL query
        Invoke-Sqlcmd -Query $sqlQuery -ConnectionString $connectionString
 

    Write-Host "Currency rates fetched and saved to the database successfully."
    }
    
    else {
    Write-Host "Failed to fetch the currency rates."
}
