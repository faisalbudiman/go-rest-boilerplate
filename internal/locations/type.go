package locations

import "net/http"

type service struct {
	repo     irepo
	log      ilogger
	response iresponse
}

type iresponse interface {
	Resp(http.ResponseWriter, int, interface{})
	Err(http.ResponseWriter, int, error)
}

type ilogger interface {
	Println(...interface{})
	Errorln(...interface{})
}

type irepo interface {
	Save(Location) error
	Select(map[string][]string, *[]Location) error
}

type idb interface {
	Save(string, ...interface{}) error
	Select(interface{}, string, ...interface{}) error
}

type ServiceConfig struct {
	Db       idb
	Repo     irepo
	Logger   ilogger
	Response iresponse
}
