env = Environment()

if ARGUMENTS.get('VERBOSE') != '1':
    '''scons VERBOSE=1'''
    env['CCCOMSTR'] = "Compiling $TARGET"
    env['CXXCOMSTR'] = "Compiling $TARGET"    
    env['LINKCOMSTR'] = "Linking $TARGET"

# Add the Debug Flags if debug=1 is specified on the command line, this tends to be compiler specific
if ARGUMENTS.get('release', 1):
    env.Append(CPPDEFINES = ['NDEBUG'])
    variant = 'Release'
else:    
    env.Append(CPPDEFINES = ['DEBUG', '_DEBUG'])
    env.Append(CCFLAGS='/MDd')
    env.Append(CCFLAGS=Split('/Zi /Fd${TARGET}.pdb'))
    env.Append(CXXFLAGS="-std=c++98")
    env.Append(LINKFLAGS = ['/DEBUG'])
    variant = 'Debug'

print("Building: " + variant)

# if env['PLATFORM'] == 'win32':
#     Help("""
#         Type: 'scons program' to build the production program,
#               'scons debug' to build the debug version.
#         """)

Export('env')

env.SConscript('src/SConscript', variant_dir='build/$PLATFORM')

if Execute(Mkdir('bin')):
    # A problem occurred while making the temp directory.
    Exit(1)
    
#env.Install('bin', main)
