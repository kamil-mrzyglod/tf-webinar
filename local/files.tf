// When working with local files, Terraform will detect the resource as having been deleted 
// each time a configuration is applied on a new machine where the file is not present 
// and will generate a diff to re-create it. This may cause "noise" in diffs in environments 
// where configurations are routinely applied by many different users or within automation systems.

resource "local_file" "foo" {
  content  = var.content
  filename = "${path.module}/generated/foo.bar"
}

resource "local_sensitive_file" "foo" {
  content  = var.content
  filename = "${path.module}/generated/foo-sensitive.bar"
}