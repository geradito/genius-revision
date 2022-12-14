<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Question;
use App\Models\Subject;
use App\Models\Category;
use App\Models\Grade;

class GradeController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $grades = Grade::has('subjects')->get(['id','name']);
        return $grades;
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
        $categories = Category::all();
        $grades = Grade::get();
        return view('grade.create')->with(['categories'=>$categories,'grades'=>$grades]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
                //Validation the Data
            $validatedData = $request->validate([
                'name' => ['required','max:255'],
                'category_id' => ['required'],
            ],
            [
                'name.required' => 'Subject name is required',
                'name.max' => 'Subject name should not be greater than 255 characters.',
                'category_id.required' => 'category id is required',
            ]);
    
            $grade = new Grade();
            $grade->name = $request->name;
            $grade->category_id = $request->category_id;
            $grade->save();
            return redirect('grades/create');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

     /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function showSubjects($id)
    {
        //
        $subjects = Subject::has('questions')->where('grade_id', $id)->get(['id','name','grade_id']);
        return $subjects;
    }
    
    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
