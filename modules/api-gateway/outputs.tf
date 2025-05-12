output "api_endpoint" {
  description = "URL publique de l’API Gateway"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}