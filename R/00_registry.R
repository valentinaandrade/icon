globalVariables("icon_fn")

dir_icon <- function(...){
  icon_fn$get(c(...))
}

icon_table <- new.env(parent = emptyenv())

# Lookup table for features
new_icon <- function(nm, fn = dir_icon) {
  icon_table[[nm]] <- environment()
  table <- new.env(parent = emptyenv())
  icon_fn <- list(
    update = function(path, meta) {
      table[["path"]] <- path
      table[["files"]] <- list_svg(path)
      table[["meta"]] <- meta
    },
    get = function(name) {
      if(!dir.exists(table$path)){
        abort("This icon library is not yet installed, install it with `download_*()`.")
      }

      files <- Reduce(`[[`, name[-length(name)], table$files)
      icon <- name[length(name)]

      if(!(icon %in% files)){
        abort(
          glue("The `{icon}` icon could not be found in this icon set.")
        )
      }

      read_icon(glue(do.call(file.path, c(list(table[["path"]]), name)), ".svg"))
    },
    list = function() {
      if(is.list(table[["files"]])) names(table[["files"]]) else table[["files"]]
    }
  )

  structure(
    set_env(fn, environment()),
    class = c("icon_set", "list")
  )
}
