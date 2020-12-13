package service

import "mbunge-admin/models/response"

type DashboardServices interface {
	GetMetrics() response.Metrics
}
