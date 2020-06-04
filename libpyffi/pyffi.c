#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <libguile.h>
#include <stdio.h>

static SCM python_object_type;

struct python_object {
  PyObject* p_data;
  SCM name;
  SCM update_func;
};

void
init_python_object_type (void)
{
  SCM name, slots;
  scm_t_struct_finalize finalizer;

  name = scm_from_utf8_symbol ("PythonObject");
  slots = scm_list_1 (scm_from_utf8_symbol ("data"));
  finalizer = NULL;

  python_object_type = scm_make_foreign_object_type (name, slots, finalizer);
}

static SCM
pyffi_Py_Initialize (void)
{
  Py_Initialize ();
  return SCM_UNSPECIFIED;
}

static SCM
pyffi_Py_IsInitialized ()
{
  int status = Py_IsInitialized ();
  return scm_from_int (status);
}

static SCM
pyffi_PyImport_AddModule (SCM s_module)
{
  char* c_name;
  struct python_object *p_module;

  p_module = (struct python_object *) scm_gc_malloc (sizeof (struct python_object), "PythonObject");
  c_name = scm_to_locale_string (s_module);
  p_module->p_data = PyImport_AddModule (c_name);
  free(c_name);
  p_module->update_func = SCM_BOOL_F;

  return scm_make_foreign_object_1 (python_object_type, p_module);
}

static SCM
pyffi_PyModule_GetDict (SCM s_module)
{
  struct python_object *p_module;
  scm_assert_foreign_object_type (python_object_type, s_module);
  p_module = scm_foreign_object_ref (s_module, 0);

  struct python_object *p_dict;
  p_dict = (struct python_object *) scm_gc_malloc (sizeof (struct python_object), "PythonObject");
  p_dict->p_data = PyModule_GetDict (p_module->p_data);
  p_dict->update_func = SCM_BOOL_F;

  return scm_make_foreign_object_1 (python_object_type, p_dict);
}

static SCM
pyffi_Py_INCREF (SCM s_obj)
{
  struct python_object *p_obj;
  scm_assert_foreign_object_type (python_object_type, s_obj);
  p_obj = scm_foreign_object_ref (s_obj, 0);
  Py_INCREF (p_obj->p_data);
  return SCM_UNSPECIFIED;
}

static SCM
pyffi_Py_DECREF (SCM s_obj)
{
  struct python_object *p_obj;
  scm_assert_foreign_object_type (python_object_type, s_obj);
  p_obj = scm_foreign_object_ref (s_obj, 0);
  Py_DECREF (p_obj->p_data);
  return SCM_UNSPECIFIED;
}

static SCM
pyffi_Py_FinalizeEx (void)
{
  int status = Py_FinalizeEx ();
  return scm_from_int (status);
}

void
init_python ()
{
  /* Register PyObject as a foreign type */
  init_python_object_type ();

  /* Register wrapper function within guile */
  scm_c_define_gsubr ("Py_Initialize", 0, 0, 0, &pyffi_Py_Initialize);
  scm_c_define_gsubr ("Py_IsInitialized", 0, 0, 0, &pyffi_Py_IsInitialized);
  scm_c_define_gsubr ("PyImport_AddModule", 1, 0, 0, &pyffi_PyImport_AddModule);
  scm_c_define_gsubr ("PyModule_GetDict", 1, 0, 0, &pyffi_PyModule_GetDict);
  scm_c_define_gsubr ("Py_INCREF", 1, 0, 0, &pyffi_Py_INCREF);
  scm_c_define_gsubr ("Py_DECREF", 1, 0, 0, &pyffi_Py_DECREF);
  scm_c_define_gsubr ("Py_FinalizeEx", 0, 0, 0, &pyffi_Py_FinalizeEx);
}
