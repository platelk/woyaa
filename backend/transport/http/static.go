package http

// WebSite serve all the field under the provided path
func (b *Builder) WebSite(path string) *Builder {
	b.e.Static("/", path)
	return b
}
