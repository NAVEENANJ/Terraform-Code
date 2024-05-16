resource "aws_api_gateway_rest_api" "apigateway" {
  name = "${var.ProjectName}-${var.servicename}-tg-${var.environment}"

  depends_on = [
    module.alb
  ]
}

resource "aws_api_gateway_resource" "parentpath" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id # In this case, the parent id should the gateway root_resource_id.
  path_part   = "api"
}

resource "aws_api_gateway_resource" "childpath" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_resource.parentpath.id # In this case, the parent id should be the parent aws_api_gateway_resource id.
  path_part   = "data"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id      = aws_api_gateway_rest_api.apigateway.id
  resource_id      = aws_api_gateway_resource.childpath.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}


resource "aws_api_gateway_integration" "test" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.childpath.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method

  type                    = "HTTP_PROXY"
  uri                     = "http://demo-alb-test-1006012731.ap-south-1.elb.amazonaws.com/api/data"
  integration_http_method = "GET"
}


resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  stage_name    = "application"
}





resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.childpath.id,
      aws_api_gateway_method.MyDemoMethod.id,
      aws_api_gateway_integration.test.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_api_key" "example" {
  name = "${var.ProjectName}-${var.servicename}-tg-${var.environment}"
}


resource "aws_api_gateway_usage_plan" "myusageplan" {
  name = "${var.ProjectName}-${var.servicename}-tg-${var.environment}"


  api_stages {
    api_id = aws_api_gateway_rest_api.apigateway.id
    stage  = aws_api_gateway_stage.example.stage_name
  }
  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.example.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.myusageplan.id
}