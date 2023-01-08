<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Question;
use App\Models\Subject;
use App\Models\Category;
use App\Models\Grade;

class SubjectController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $subjects = Subject::has('questions')->get(['id','name','category_id', 'grade_id']);
        return $subjects;
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
        $grades = Grade::all();
        $subjects = Subject::all();
        return view('subject.create')->with(['categories'=>$categories,'grades'=>$grades,'subjects'=>$subjects]);
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
                'grade_id' => ['required'],
            ],
            [
                'name.required' => 'Subject name is required',
                'name.max' => 'Subject name should not be greater than 255 characters.',
                'grade_id.required' => 'grade id is required',
            ]);

        $subject = new Subject();
        $subject->name = $request->name;
        $subject->category_id = Grade::where('id',$request->grade_id)->first()['category_id'];
        $subject->grade_id = $request->grade_id;
        $subject->save();
        return redirect('subjects/create');
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
    public function showQuestions($id)
    {
        //
        $questions = Question::where('subject_id', $id)
        ->get(['id', 'question','diagram', 'option_a', 'option_b', 'option_c', 'option_d', 'answer','subject_id']);
        return $questions;
       
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
