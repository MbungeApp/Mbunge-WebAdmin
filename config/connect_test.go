package config

import (
	"go.mongodb.org/mongo-driver/mongo"
	"reflect"
	"testing"
)

func TestConnectDB(t *testing.T) {
	tests := []struct {
		name string
		want *mongo.Client
	}{
		{
			name: "test db",
			want: ConnectDB(),
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ConnectDB(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ConnectDB() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestErrorReporter(t *testing.T) {
	type args struct {
		report string
	}
	tests := []struct {
		name string
		args args
	}{
		{
			name: "test reporter",
			args: args{
				report: "My test",
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
		})
	}
}

func TestGetKey(t *testing.T) {
	type args struct {
		section string
		key     string
	}
	tests := []struct {
		name    string
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "Test mongo config",
			args: args{
				section: "mongodb",
				key:     "url",
			},
			want:    "mongodb+srv://root:bonoko1289@cluster0.0snut.mongodb.net/Cluster0?retryWrites=true&w=majority",
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetKey(tt.args.section, tt.args.key)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetKey() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("GetKey() got = %v, want %v", got, tt.want)
			}
		})
	}
}
