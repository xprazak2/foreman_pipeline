collection @collection

extends "katello/api/v2/common/metadata"

child @collection[:results] => :results do
  extends("integration/%s/show" % controller_name)
end