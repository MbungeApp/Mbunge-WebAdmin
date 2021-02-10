package dao

import (
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
	"reflect"
	"testing"
)

func TestNewNewsDaoInterface_CreateNews(t *testing.T) {
	type fields struct {
		Client *mongo.Client
	}
	type args struct {
		news db.EventNew
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := NewNewsDaoInterface{
				Client: tt.fields.Client,
			}
			if err := n.CreateNews(tt.args.news); (err != nil) != tt.wantErr {
				t.Errorf("CreateNews() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestNewNewsDaoInterface_DeleteNews(t *testing.T) {
	type fields struct {
		Client *mongo.Client
	}
	type args struct {
		newsID string
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := NewNewsDaoInterface{
				Client: tt.fields.Client,
			}
			if err := n.DeleteNews(tt.args.newsID); (err != nil) != tt.wantErr {
				t.Errorf("DeleteNews() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestNewNewsDaoInterface_ReadAllNews(t *testing.T) {
	type fields struct {
		Client *mongo.Client
	}
	tests := []struct {
		name    string
		fields  fields
		want    []db.EventNew
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := NewNewsDaoInterface{
				Client: tt.fields.Client,
			}
			got, err := n.ReadAllNews()
			if (err != nil) != tt.wantErr {
				t.Errorf("ReadAllNews() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ReadAllNews() got = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestNewNewsDaoInterface_ReadOneNews(t *testing.T) {
	type fields struct {
		Client *mongo.Client
	}
	type args struct {
		newsID string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   db.EventNew
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := NewNewsDaoInterface{
				Client: tt.fields.Client,
			}
			if got := n.ReadOneNews(tt.args.newsID); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ReadOneNews() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestNewNewsDaoInterface_TotalNews(t *testing.T) {
	type fields struct {
		Client *mongo.Client
	}
	tests := []struct {
		name   string
		fields fields
		want   int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := NewNewsDaoInterface{
				Client: tt.fields.Client,
			}
			if got := n.TotalNews(); got != tt.want {
				t.Errorf("TotalNews() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestNewNewsDaoInterface_UpdateNews(t *testing.T) {
	type fields struct {
		Client *mongo.Client
	}
	type args struct {
		newsID string
		key    string
		value  string
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			n := NewNewsDaoInterface{
				Client: tt.fields.Client,
			}
			if err := n.UpdateNews(tt.args.newsID, tt.args.key, tt.args.value); (err != nil) != tt.wantErr {
				t.Errorf("UpdateNews() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func Test_newsCollection(t *testing.T) {
	type args struct {
		client *mongo.Client
	}
	tests := []struct {
		name string
		args args
		want *mongo.Collection
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := newsCollection(tt.args.client); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("newsCollection() = %v, want %v", got, tt.want)
			}
		})
	}
}
